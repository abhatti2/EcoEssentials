# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # Welcome Message
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Example of a simple dashboard with columns and panels
    columns do
      # Left Column: Recent Products
      column do
        panel "Recent Products" do
          ul do
            Product.order(created_at: :desc).limit(5).map do |product|
              li link_to(product.name, admin_product_path(product))
            end
          end
        end
      end

      # Right Column: System Info or Custom Panels
      column do
        panel "Admin Info" do
          para "Welcome, #{current_admin_user.email}!"
          para "Today is #{Date.today.strftime('%B %d, %Y')}"
        end

        panel "Quick Links" do
          ul do
            li link_to "Manage Products", admin_products_path
            li link_to "Manage Static Pages", admin_static_pages_path
          end
        end
      end
    end
  end # content
end
