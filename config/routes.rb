Rails.application.routes.draw do
  root 'stories#index'
  get 'search', to: 'stories#search'
end
