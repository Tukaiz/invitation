Invitation::Engine.routes.draw do
  resources :invitations, only: [:new, :create]
  get '/invitations/accept', to: 'invitations#edit', as: :edit_invitation
  put '/invitations/accept', to: 'invitations#update', as: :update_invitation
end
