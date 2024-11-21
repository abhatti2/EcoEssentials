ActiveAdmin.register StaticPage do
  permit_params :title, :content, :slug

  index do
    selectable_column
    id_column
    column :title
    column :slug
    actions
  end

  filter :title
  filter :slug

  form do |f|
    f.inputs "Static Page Details" do
      f.input :title
      f.input :slug
      f.input :content, as: :text
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :content
      row :created_at
      row :updated_at
    end
  end
end
