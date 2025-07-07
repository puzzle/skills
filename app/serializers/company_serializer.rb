# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
#
#  id                      :bigint(8)        not null, primary key
#  name                    :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  associations_updated_at :datetime
#

class CompanySerializer < ApplicationSerializer
  attributes :id, :name, :created_at, :updated_at

  has_many :people, serializer: PersonMinimalSerializer
end
