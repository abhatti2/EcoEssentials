class CartController < ApplicationController
  def add
    session[:cart] ||= {}
    product_id = params[:product_id]
    session[:cart][product_id] = (session[:cart][product_id] || 0) + params[:quantity].to_i
    redirect_to cart_path, notice: "Product added to cart."
  end

  def show
    @cart_items = session[:cart]&.map do |product_id, quantity|
      product = Product.find(product_id)
      { product: product, quantity: quantity }
    end || []
  end

  def remove
    session[:cart]&.delete(params[:product_id])
    redirect_to cart_path, notice: "Product removed from cart."
  end

  def checkout
    # Implement checkout logic here
  end
end
