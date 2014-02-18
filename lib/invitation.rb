require "invitation/engine"
require "feature_system"

module Invitation
  # Specify attributes that can be configured
  mattr_accessor :uri_class_name

  #pass self to yield so it can be configured by
  #the client app
  def self.configure
    yield self
  end

  class InvitationFeatureDefinition
    include FeatureSystem::Provides
  end

  module Authorization
    module Permissions
    end
  end
end
