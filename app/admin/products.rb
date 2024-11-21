ActiveAdmin.register Product do
  # Permitted parameters for product creation and updates
  permit_params :name, :description, :current_price, :stock_quantity

  # Index Page Configuration
  index do
    selectable_column
    id_column
    column :name
    column :current_price
    column :stock_quantity
    column :created_at
    actions
  end

  # Filters for searching products
  filter :name
  filter :current_price
  filter :stock_quantity
  filter :created_at

  # Form for creating and editing products
  form do |f|
    f.inputs "Product Details" do
      f.input :name, placeholder: "Enter the product name"
      f.input :description, as: :text, placeholder: "Enter a brief description"
      f.input :current_price, placeholder: "Enter the product price"
      f.input :stock_quantity, placeholder: "Enter available stock quantity"
    end
    f.actions
  end

  # Show Page Configuration
  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :current_price
      row :stock_quantity
      row :created_at
      row :updated_at
    end
  end
end
