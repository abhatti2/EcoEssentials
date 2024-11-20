Rails.application.routes.draw do
  # Public routes
  root 'home#index'
  get 'about', to: 'home#about'
  get 'contact', to: 'home#contact'

  # Product display routes
  resources :products, only: [:index, :show]

  # Cart routes
  resource :cart, only: [:show] do
    post :add
    delete :remove
    get :checkout
  end

  # Admin routes
  devise_for :admins

  namespace :admin do
    root to: "dashboard#index"
    resources :products
  end

  # Health check route (for server monitoring)
  get "up", to: "rails/health#show", as: :rails_health_check

  # Uncomment if using PWA (Progressive Web App) support
  # get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
end
