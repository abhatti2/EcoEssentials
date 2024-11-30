class OrdersController < ApplicationController
  include CartsHelper # Include the helper to access tax rates

  def show
    @order = Order.includes(:customer, order_items: :product).find_by(id: params[:id])

    if @order.nil?
      redirect_to root_path, alert: "Order not found."
      return
    end

    # Recalculate totals for confirmation (useful for ensuring accuracy)
    calculate_order_summary(@order)
  end

  private

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
