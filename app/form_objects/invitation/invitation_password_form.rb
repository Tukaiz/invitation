module Invitation
  class InvitationPasswordForm
    include ActiveModel::Model
    attr_accessor :invitation_token, :password, :password_confirmation
    validates :password, :password_confirmation, presence: true
    validates_confirmation_of :password


    def initialize(args = {})
      @invitation_token      = args[:invitation_token]
      @password              = args[:password]
      @password_confirmation = args[:password_confirmation]
    end

    def update
      if self.valid?
        if response.success?
          true
        else
          response["errors"].each do |k, v|
            v.each do |message|
              self.errors.add(k.to_sym, message)
            end
          end
          false
        end
      end
    end

    private

    def response
      @response ||= HTTParty.put(invitation_uri,
                      body: {user:{ password: password,
                                    invitation_token: invitation_token }
                                  })
    end

    def invitation_uri
      uri_class.invitation.to_s
    end

    def uri_class
      Invitation.uri_class_name.constantize
    end
  end
end
