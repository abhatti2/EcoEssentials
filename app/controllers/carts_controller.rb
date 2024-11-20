class CartsController < ApplicationController
  before_action :initialize_cart, only: [:add, :remove]

  def show
    @cart_items = session[:cart]&.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      { product: product, quantity: quantity } if product
    end&.compact || []
  end

  def add
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    if product_id.present? && quantity.positive?
      session[:cart][product_id] = (session[:cart][product_id] || 0) + quantity
      redirect_to cart_path, notice: "Product added to cart."
    else
      redirect_to cart_path, alert: "Invalid product or quantity."
    end
  end

  def remove
    product_id = params[:product_id]

    if session[:cart]&.delete(product_id)
      redirect_to cart_path, notice: "Product removed from cart."
    else
      redirect_to cart_path, alert: "Product not found in cart."
    end
  end

  def checkout
    if session[:cart].present?
      @cart_items = session[:cart].map do |product_id, quantity|
        product = Product.find_by(id: product_id)
        { product: product, quantity: quantity } if product
      end&.compact

      if @cart_items.any?
        # Placeholder for real checkout logic
        session[:cart] = nil # Clear the cart after checkout
        redirect_to root_path, notice: "Checkout successful!"
      else
        redirect_to cart_path, alert: "Unable to process checkout. Cart is empty."
      end
    else
      redirect_to cart_path, alert: "Your cart is empty. Add items before checkout."
    end
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end
end
