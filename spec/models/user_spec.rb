# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  ldap_uid                     :string
#  api_token                    :string
#  failed_login_attempts        :integer          default(0)
#  last_failed_login_attempt_at :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

require 'rails_helper'

describe User do
  context 'authentication' do
    it 'generates API key on first login' do
      allow(LdapTools).to receive(:exists?).and_return(1234)
      allow(LdapTools).to receive(:find_user).and_return({:cn=>["Peter"]})
      allow(LdapTools).to receive(:authenticate).and_return(true)

      User.authenticate('new_user', 'password')

      new_user = User.find_by(ldap_uid: 'new_user')

      expect(new_user.api_token.present?).to be true
    end
  end
end
