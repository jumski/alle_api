AlleApi::Engine.routes.draw do
  resources :categories, only: [:index], format: :json
  resources :shipment_prices, only: [:index], format: :json
  resources :auctions, only: [:preview] do
    get :preview, on: :member
  end
end
