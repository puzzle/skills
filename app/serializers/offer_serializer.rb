# == Schema Information
#
# Table name: offers
#
#  id         :bigint(8)        not null, primary key
#  category   :string
#  offer      :text             default([]), is an Array
#  company_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OfferSerializer < ApplicationSerializer
  attributes :id, :category, :offer
  belongs_to :company, serializer: CompanyInPersonSerializer
end
