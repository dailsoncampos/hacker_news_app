Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'stories#index'

  resources :stories, only: [:index] do
    collection do
      get 'search'
    end
  end
end
