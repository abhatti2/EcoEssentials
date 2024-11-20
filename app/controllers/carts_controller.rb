class CartsController < ApplicationController
  def show
    @cart_items = session[:cart]&.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      { product: product, quantity: quantity } if product
    end&.compact || []
  end

  def add
    session[:cart] ||= {}
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    session[:cart][product_id] = (session[:cart][product_id] || 0) + quantity
    redirect_to cart_path, notice: "Product added to cart."
  end

  def remove
    session[:cart]&.delete(params[:product_id])
    redirect_to cart_path, notice: "Product removed from cart."
  end

  def checkout
    # Placeholder for checkout functionality
  end
end
