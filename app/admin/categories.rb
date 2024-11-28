ActiveAdmin.register Category do
  permit_params :name

  # Index Page Configuration
  index do
    selectable_column
    id_column
    column :name
    column "Number of Products" do |category|
      category.products.count
    end
    column :created_at
    column :updated_at
    actions
  end

  # Filters for searching categories
  filter :name
  filter :products_name_cont, as: :string, label: "Product Name" # Allows searching categories by product name
  filter :created_at
  filter :updated_at

  # Form for creating and editing categories
  form do |f|
    f.inputs "Category Details" do
      f.input :name, placeholder: "Enter the category name"
    end
    f.actions
  end

  # Show Page Configuration
  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end

    panel "Products in this Category" do
      if category.products.any?
        table_for category.products do
          column :id
          column :name
          column :current_price do |product|
            number_to_currency(product.current_price, unit: "$")
          end
          column :stock_quantity
          column :created_at
          column("") do |product|
            span link_to "View", admin_product_path(product), class: "btn btn-sm btn-info"
            span link_to "Edit", edit_admin_product_path(product), class: "btn btn-sm btn-warning ml-2"
          end
        end
      else
        div class: "text-muted" do
          "No products assigned to this category."
        end
      end
    end
  end

  # Sidebar showing total number of products in this category
  sidebar "Category Details", only: [ :show, :edit ] do
    ul do
      li "Total Products: #{category.products.count}"
      li "Average Price: #{number_to_currency(category.products.average(:current_price) || 0, unit: "$")}"
    end
  end

  # Batch actions for assigning or removing categories (optional)
  batch_action :assign_to_category, form: -> { { Category: Category.pluck(:name, :id) } } do |ids, inputs|
    Category.find(inputs["Category"]).products << Product.find(ids)
    redirect_back fallback_location: admin_categories_path, notice: "Products successfully assigned to category."
  end
end
