Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'stories#index'
  get 'search', to: 'stories#search'
end
