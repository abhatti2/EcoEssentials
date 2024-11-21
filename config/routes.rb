Rails.application.routes.draw do
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
    post :add
    delete :remove
    get :checkout
  end

  # Health check route for server monitoring
  get "up", to: "rails/health#show", as: :rails_health_check

  # Uncomment if using PWA (Progressive Web App) support
  # get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
end
