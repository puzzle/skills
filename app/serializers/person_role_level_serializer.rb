# frozen_string_literal: true

# == Schema Information
#
# Table name: person_role_levels
#
#  id        :bigint(8)        not null, primary key
#  level     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PersonRoleLevelSerializer < ApplicationSerializer
  attributes :id, :level
end
