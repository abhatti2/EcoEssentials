class CartsController < ApplicationController
  include CartsHelper # Include the helper to access tax rates

  before_action :initialize_cart

  def show
    @cart_items = fetch_cart_items
  end

  def add
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    if valid_product_and_quantity?(product_id, quantity)
      session[:cart][product_id] = (session[:cart][product_id] || 0) + quantity
      redirect_to cart_path, notice: "Product successfully added to cart."
    else
      redirect_to products_path, alert: "Invalid product or quantity."
    end
  end

  def update_quantity
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    if valid_product_and_quantity?(product_id, quantity)
      session[:cart][product_id] = quantity
      redirect_to cart_path, notice: "Quantity updated successfully."
    else
      redirect_to cart_path, alert: "Invalid product or quantity."
    end
  end

  def remove
    product_id = params[:product_id]

    if session[:cart]&.delete(product_id)
      redirect_to cart_path, notice: "Product successfully removed from cart."
    else
      redirect_to cart_path, alert: "Product not found in the cart."
    end
  end

  def clear
    session[:cart] = {}
    redirect_to cart_path, notice: "Your cart has been cleared."
  end

  def checkout
    @cart_items = fetch_cart_items

    if @cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty. Add items before checking out."
      return
    end

    @customer = user_signed_in? ? map_user_to_customer(current_user) : Customer.new
    @provinces = province_tax_rates.keys
    calculate_summary(@customer.province || @provinces.first)
  end

  def update_summary
    @customer = Customer.new(customer_params)
    @cart_items = fetch_cart_items
    @provinces = province_tax_rates.keys

    if @customer.valid?(:tax_calculation) # Use custom validation context
      calculate_summary(@customer.province)
      flash.now[:notice] = "Order summary updated."
    else
      flash.now[:alert] = "Please correct the errors in the form."
    end

    render :checkout
  end

  def place_order
    @cart_items = fetch_cart_items

    if @cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty. Add items before placing an order."
      return
    end

    @customer = user_signed_in? ? map_user_to_customer(current_user) : Customer.find_or_initialize_by(email: customer_params[:email])
    @customer.assign_attributes(customer_params)

    if @customer.save
      ActiveRecord::Base.transaction do
        @order = Order.create!(
          customer: @customer,
          order_date: Time.zone.now,
          status: "pending",
          total_amount: calculate_total_with_taxes(@customer.province)
        )

        @cart_items.each do |entry|
          @order.order_items.create!(
            product: entry[:product],
            quantity: entry[:quantity],
            price_at_purchase: entry[:product].current_price
          )
        end
      end

      session[:cart] = nil
      redirect_to order_confirmation_path(@order.id), notice: "Checkout successful! Thank you for your purchase."
    else
      flash.now[:alert] = "Please correct the errors in the form."
      @cart_items = fetch_cart_items
      @provinces = province_tax_rates.keys
      calculate_summary(customer_params[:province])
      render :checkout
    end
  rescue ActiveRecord::RecordInvalid => e
    logger.error "Order placement failed: #{e.message}"
    flash.now[:alert] = "An error occurred while placing your order. Please try again."
    @cart_items = fetch_cart_items
    @provinces = province_tax_rates.keys
    calculate_summary(customer_params[:province])
    render :checkout
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end

  def valid_product_and_quantity?(product_id, quantity)
    product_id.present? && quantity.positive? && Product.exists?(product_id)
  end

  def fetch_cart_items
    return [] if session[:cart].blank?

    product_ids = session[:cart].keys
    products = Product.where(id: product_ids).index_by(&:id)

    session[:cart].map do |product_id, quantity|
      product = products[product_id.to_i]
      { product: product, quantity: quantity } if product
    end.compact
  end

  def customer_params
    params.fetch(:customer, {}).permit(:first_name, :last_name, :email, :address, :city, :postal_code, :phone, :province)
  end

  def map_user_to_customer(user)
    Customer.find_or_create_by(email: user.email) do |customer|
      customer.first_name = user.first_name
      customer.last_name = user.last_name
      customer.address = user.address
      customer.city = user.city
      customer.province = user.province
      customer.postal_code = user.postal_code
      customer.phone = user.phone
    end
  end

  def calculate_total_with_taxes(province)
    @cart_items ||= fetch_cart_items
    tax_rates = province_tax_rates[province]
    subtotal = @cart_items.sum { |entry| entry[:product].current_price * entry[:quantity] }

    pst = subtotal * (tax_rates[:pst] || 0.0)
    gst = subtotal * (tax_rates[:gst] || 0.0)
    hst = subtotal * (tax_rates[:hst] || 0.0)

    subtotal + pst + gst + hst
  end

  def calculate_summary(province)
    @cart_items ||= fetch_cart_items
    tax_rates = province_tax_rates[province]
    @subtotal = @cart_items.sum { |entry| entry[:product].current_price * entry[:quantity] }
    @pst = @subtotal * (tax_rates[:pst] || 0.0)
    @gst = @subtotal * (tax_rates[:gst] || 0.0)
    @hst = @subtotal * (tax_rates[:hst] || 0.0)
    @total = @subtotal + @pst + @gst + @hst
  end
end
