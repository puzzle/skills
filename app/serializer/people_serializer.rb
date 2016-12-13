class PeopleSerializer < ApplicationSerializer
  attributes :id, :birthdate, :language, :profile_picture, :location, :martial_status, :updated_by,
             :name, :origin, :role, :title
end
