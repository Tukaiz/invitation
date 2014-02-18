module Invitation
  class InvitationService
    attr_accessor :email, :site_name, :site_uri

    def initialize(email, site_name, site_uri)
      @email = email
      @site_name = site_name
      @site_uri  = site_uri
    end

    def invite
      HTTParty.post(Invitation.uri_class_name.constantize.invitation.to_s,
                        body: {user:{ email: email,
                          site_name: site_name,
                          site_uri: site_uri }})
    end
  end
end
