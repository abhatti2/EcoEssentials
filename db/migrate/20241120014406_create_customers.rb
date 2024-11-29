class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :address
      t.string :city
      t.string :province, null: false # Province is required for tax calculation
      t.string :postal_code
      t.string :phone

      t.timestamps
    end

    # Adding an index to speed up lookups by email (useful for checking existing customers)
    add_index :customers, :email, unique: true
  end
end
