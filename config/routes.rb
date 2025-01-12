Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "movies#index"
  resources :movies, only: [:index] do
    collection do
      post :fetch_recommendations
      post :store_movie
      post :truncate_favorites
    end
  end
end