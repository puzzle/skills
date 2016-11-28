require 'LdapTools'

module ControllerHelpers
  def auth(user)
    user = users(user) unless user.is_a?(User)
    expect_any_instance_of(ApplicationController).to receive(:authorize).and_return(true)
  end
end
