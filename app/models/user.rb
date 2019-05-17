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

class User < ApplicationRecord
end
