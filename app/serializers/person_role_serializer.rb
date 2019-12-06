# frozen_string_literal: true

# == Schema Information
#
# Table name: person_roles
#
#  id                    :bigint(8)        not null, primary key
#  person_id             :bigint(8)
#  role_id               :bigint(8)
#  person_role_level     :integer
#  percent               :decimal(5, 2)
#

class PersonRoleSerializer < ApplicationSerializer
  attributes :id, :percent

  belongs_to :person_role_level
  belongs_to :person, serializer: PersonUpdatedAtSerializer
  belongs_to :role, serializer: RoleSerializer
end
