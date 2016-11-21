require 'LdapTools'

module ControllerHelpers
  def auth(user)
    user = users(user) unless user.is_a?(User)
    allow(Rails.env).to receive(:development?).and_return(true)
  end
end
