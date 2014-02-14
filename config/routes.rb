Invitation::Engine.routes.draw do
  constraints FeatureConstraint.new(:invitation) do
    namespace :admin do
      resources :invitations, only: [:new, :create]
    end
    get '/invitations/accept', to: 'invitations#edit', as: :edit_invitation
    put '/invitations/accept', to: 'invitations#update', as: :update_invitation
  end
end
