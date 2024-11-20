class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address
      t.string :city
      t.string :postal_code
      t.string :phone

      t.timestamps
    end
    add_index :customers, :email
  end
end
