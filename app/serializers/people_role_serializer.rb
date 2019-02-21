# == Schema Information
#
# Table name: people_roles
#
#  id        :bigint(8)        not null, primary key
#  person_id :bigint(8)
#  role_id   :bigint(8)
#  level     :string
#  percent   :decimal(5, 2)
#

class PeopleRoleSerializer < ApplicationSerializer
  attributes :id, :person_id, :role_id, :level, :percent

  belongs_to :person, serializer: PersonUpdatedAtSerializer
  belongs_to :role, serializer: RoleSerializer
end
