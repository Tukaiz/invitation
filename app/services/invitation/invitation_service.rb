module Invitation
  class InvitationService
    # Dependencies on CasUri, HTTParty, and Cas::Authorization should
    # be looked into
    include Cas::Authorization
    attr_accessor :email, :site_name, :site_uri

    def initialize(email, site_name, site_uri)
      @email = email
      @site_name = site_name
      @site_uri  = site_uri
    end

    def invite
      HTTParty.post(CasUri.invitation.to_s,
                        body: {user:{ email: email,
                          site_name: site_name,
                          site_uri: site_uri }},
                          headers: self.headers)
    end
  end
end
