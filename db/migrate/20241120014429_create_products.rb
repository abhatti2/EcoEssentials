class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :current_price
      t.integer :stock_quantity

      t.timestamps
    end
  end
end
