Rails.application.routes.draw do
  # Devise for Users with custom controllers
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "devise/sessions"
  }

  # Devise for ActiveAdmin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Static Pages (Dynamic Routes)
  get "/pages/:slug", to: "static_pages#show", as: :static_page

  # Root route for the public home page
  root "home#index"

  # Public Product display routes
  resources :products, only: [ :index, :show ]

  # Cart routes
  resource :cart, only: [ :show ] do
    post :add, to: "carts#add", as: :add
    patch :update_quantity, to: "carts#update_quantity", as: :update_quantity
    delete :remove, to: "carts#remove", as: :remove
    delete :clear, to: "carts#clear", as: :clear
    get :checkout, to: "carts#checkout", as: :checkout
    patch :update_summary, to: "carts#update_summary", as: :update_summary # Route for updating the order summary
    post :place_order, to: "carts#place_order", as: :place_order
  end

  # Order routes
  resources :orders, only: [ :index, :show ] # Route for viewing order history and order details

  # Order confirmation route
  get "order_confirmation/:id", to: "orders#show", as: :order_confirmation # Route for displaying the order confirmation

  # Health check route for server monitoring
  get "up", to: "rails/health#show", as: :rails_health_check

  # Uncomment if using PWA (Progressive Web App) support
  # get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
end
