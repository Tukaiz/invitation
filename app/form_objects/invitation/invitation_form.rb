module Invitation
  class InvitationForm
    include ActiveModel::Model
    attr_accessor :email, :current_site_name, :accept_invitation_url
    validates :email, presence: true
    def initialize(args = {})
      @email                 = args[:email]
      @current_site_name     = args[:current_site_name]
      @accept_invitation_url = args[:accept_invitation_url]
    end

    def save
      service = InvitationService.new(email, current_site_name, accept_invitation_url)
      res = service.invite

      if res.success?
        true
      else
        res["errors"].each do |k, v|
          v.each do |message|
            self.errors.add(k.to_sym, message)
          end
        end
        false
      end
    end
  end
end
