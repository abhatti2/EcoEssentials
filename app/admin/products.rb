ActiveAdmin.register Product do
  # Permitted parameters for product creation and updates
  permit_params :name, :description, :current_price, :stock_quantity, :category_id

  # Index Page Configuration
  index do
    h2 "Manage Products", class: "title-with-count"
    div class: "panel mb-4" do
      div class: "panel-header" do
        link_to "Add New Product", new_admin_product_path, class: "btn btn-primary"
      end
      div class: "panel-body" do
        para "Total Products: #{Product.count}", class: "panel-summary"
      end
    end

    selectable_column
    id_column
    column :name
    column :description do |product|
      truncate(product.description, length: 50)
    end
    column "Category" do |product|
      product.category&.name || "Unassigned"
    end
    column :current_price do |product|
      number_to_currency(product.current_price, unit: "$")
    end
    column :stock_quantity
    actions defaults: true do |product|
      link_to "View", admin_product_path(product), class: "view-link"
    end
  end

  # Filters for searching products
  filter :name
  filter :category, as: :select, collection: -> { Category.pluck(:name, :id) }
  filter :current_price, as: :numeric_range_filter
  filter :stock_quantity, as: :numeric_range_filter
  filter :created_at

  # Form for creating and editing products
  form do |f|
    f.inputs "Product Details" do
      f.input :name, placeholder: "Enter the product name"
      f.input :description, placeholder: "Enter a brief description", input_html: { rows: 4 }
      f.input :current_price, placeholder: "Enter the product price", hint: "Use decimal format (e.g., 19.99)"
      f.input :stock_quantity, placeholder: "Enter available stock quantity", hint: "Enter a whole number"
      f.input :category, as: :select, collection: Category.all.map { |category| [ category.name, category.id ] }, include_blank: "Select a category"
    end
    f.actions
  end

  # Show Page Configuration
  show do
    attributes_table do
      row :id
      row :name
      row :description do |product|
        simple_format(product.description)
      end
      row "Category" do |product|
        product.category.present? ? link_to(product.category.name, admin_category_path(product.category), class: "text-decoration-none") : "Unassigned"
      end
      row :current_price do |product|
        number_to_currency(product.current_price, unit: "$")
      end
      row :stock_quantity
      row :created_at do |product|
        product.created_at.strftime("%B %d, %Y %H:%M")
      end
      row :updated_at do |product|
        product.updated_at.strftime("%B %d, %Y %H:%M")
      end
    end
  end

  # Sidebar showing product metadata
  sidebar "Product Details", only: :show do
    attributes_table_for resource do
      row :id
      row "Category" do |product|
        product.category&.name || "Unassigned"
      end
      row :created_at
      row :updated_at
    end
  end
end
