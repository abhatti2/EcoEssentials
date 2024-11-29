class AddProvinceToCustomers < ActiveRecord::Migration[8.0]
  def change
    add_column :customers, :province, :string
  end
end
