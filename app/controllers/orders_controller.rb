class OrdersController < ApplicationController
  def show
    @order = Order.includes(:customer, order_items: :product).find(params[:id])

    # Recalculate totals for confirmation (useful for ensuring accuracy)
    province = @order.customer.province
    tax_rates = province_tax_rates[province]
    @subtotal = @order.order_items.sum { |item| item.quantity * item.price_at_purchase }
    @pst = @subtotal * (tax_rates[:pst] || 0.0)
    @gst = @subtotal * (tax_rates[:gst] || 0.0)
    @hst = @subtotal * (tax_rates[:hst] || 0.0)
    @total = @subtotal + @pst + @gst + @hst
  end
end
