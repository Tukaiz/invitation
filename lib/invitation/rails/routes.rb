module ActionDispatch::Routing
  class Mapper
    def invitation_mount_invite
      get @scope[:path] + '/invitations/new', to: 'invitation/invitations#new'
    end

    def invitation_mount_accept
      get '/invitations/accept', to: 'invitation/invitations#edit'
      put '/invitations/accept', to: 'invitation/invitations#update'
    end
  end
end
