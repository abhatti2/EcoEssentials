Rails.application.routes.draw do
  get "cart/show"
  get "cart/add"
  get "cart/remove"
  get "cart/checkout"
  get "home/index"
  get "home/about"
  get "home/contact"
  namespace :admin do
    get "dashboard/index"
  end
  devise_for :admins
namespace :admin do
  root to: "dashboard#index"
  resources :products
end

root 'home#index'
get 'about', to: 'home#about'
get 'contact', to: 'home#contact'
resources :products, only: [:index, :show]

resource :cart, only: [:show] do
  post :add
  delete :remove
  get :checkout
end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
