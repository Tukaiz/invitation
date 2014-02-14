module Invitation
  class InvitationPasswordForm
    include Cas::Authorization
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
          create_local_user
          # auth server returns users email address upon successful
          # setting of account password
          response.headers["account_email"]
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

    def account_email
      response.headers["account_email"]
    end

    private

    def cas_user_id
      response.headers["cas_user_id"]
    end

    ## TO-DO,  This should bubble up errors to the form object,
    ## if the User.create == false.
    def create_local_user
      access_request = AccessRequest.find_by(username: account_email)
      if access_request
        User.create(first: access_request.first_name,
                    last: access_request.last_name,
                    username: account_email,
                    cas_user_id: access_request.cas_user_id)
      end
    end

    def response
      @response ||= HTTParty.put(CasUri.invitation.to_s,
                      body: {user:{ password: password,
                                    invitation_token: invitation_token }
                                  }, headers: self.headers)
    end

  end
end
