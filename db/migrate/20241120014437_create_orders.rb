class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true # Link to customer
      t.datetime :order_date, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.string :status, null: false, default: "pending" # Order status
      t.decimal :subtotal, precision: 10, scale: 2, null: false # Total before taxes
      t.decimal :gst, precision: 10, scale: 2, default: 0.0 # GST amount
      t.decimal :pst, precision: 10, scale: 2, default: 0.0 # PST amount
      t.decimal :hst, precision: 10, scale: 2, default: 0.0 # HST amount
      t.decimal :total_amount, precision: 10, scale: 2, null: false # Final total

      t.timestamps
    end
  end
end
