Invitation::Engine.routes.draw do
  resources :invitations, only: [:new, :create]
  get '/users/invitation/accept', to: 'invitations#edit', as: :edit_invitation
  put '/users/invitation/accept', to: 'invitations#update', as: :update_invitation
end
