require "invitation/engine"
require "feature_system"

module Invitation
  class InvitationFeatureDefinition
    include FeatureSystem::Provides
  end

  module Authorization
    module Permissions
    end
  end
end
