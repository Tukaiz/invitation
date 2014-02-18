Rails.application.routes.draw do
  resources :main
  root to: 'main#index', :via => [:get]
  mount Invitation::Engine => "/invitation"
end
