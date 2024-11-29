class CartsController < ApplicationController
  before_action :initialize_cart

  def show
    # Fetch and structure the cart items from session
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

  def remove
    product_id = params[:product_id]

    if session[:cart]&.delete(product_id)
      redirect_to cart_path, notice: "Product successfully removed from cart."
    else
      redirect_to cart_path, alert: "Product not found in the cart."
    end
  end

  def clear
    session[:cart] = {} # Clear all items from the cart
    redirect_to cart_path, notice: "Your cart has been cleared."
  end

  def checkout
    @cart_items = fetch_cart_items

    if @cart_items.any?
      # Placeholder for real checkout logic (e.g., creating an order, payment, etc.)
      session[:cart] = nil # Clear the cart after successful checkout
      redirect_to root_path, notice: "Checkout successful! Thank you for your purchase."
    else
      redirect_to cart_path, alert: "Your cart is empty. Add items before checking out."
    end
  end

  private

  # Initializes the cart session
  def initialize_cart
    session[:cart] ||= {}
  end

  # Validates if a product ID and quantity are valid
  def valid_product_and_quantity?(product_id, quantity)
    product_id.present? && quantity.positive? && Product.exists?(product_id)
  end

  # Fetches and formats the cart items from session
  def fetch_cart_items
    session[:cart].map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      { product: product, quantity: quantity } if product
    end.compact
  end
end
