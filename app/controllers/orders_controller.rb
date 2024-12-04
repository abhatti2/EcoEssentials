class OrdersController < ApplicationController
  include CartsHelper # Include the helper to access tax rates
  before_action :authenticate_user! # Ensure only logged-in customers can access their orders
  before_action :ensure_customer # Ensure a customer record exists for the user

  def index
    # Fetch all orders for the logged-in user through their associated customer
    @orders = current_user.customer.orders.includes(order_items: :product).order(order_date: :desc)
  end

  def show
    # Fetch the specific order belonging to the logged-in user's customer
    @order = current_user.customer.orders.includes(order_items: :product).find_by(id: params[:id])

    if @order.nil?
      redirect_to orders_path, alert: "Order not found."
      return
    end

    # Recalculate totals for display (optional, based on existing stored values)
    calculate_order_summary(@order)
  end

  private

  # Ensure the current user has an associated customer record
  def ensure_customer
    current_user.ensure_customer
  end

  # Calculates order summary (subtotal, taxes, and total)
  def calculate_order_summary(order)
    province = order.customer.province
    tax_rates = province_tax_rates[province]

    @subtotal = order.order_items.sum { |item| item.quantity * item.price_at_purchase }
    @pst = @subtotal * (tax_rates[:pst] || 0.0)
    @gst = @subtotal * (tax_rates[:gst] || 0.0)
    @hst = @subtotal * (tax_rates[:hst] || 0.0)
    @total = @subtotal + @pst + @gst + @hst
  end
end
