# == Schema Information
#
# Table name: locations
#
#  id         :bigint(8)        not null, primary key
#  location   :string
#  company_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LocationSerializer < ApplicationSerializer
  attributes :id, :location
  belongs_to :company, serializer: CompanyInPersonSerializer
end
