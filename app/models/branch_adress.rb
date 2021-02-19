# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
#
#  id                      :bigint(8)        not null, primary key
#  short_name              :string
#  adress_information      :string
#  country                 :strings
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class BranchAdress < ApplicationRecord
  validates :short_name, :country, :default_branch_adress, :adress_information, presence: true
  validates :adress_information, length: { maximum: 200 }

  scope :list, -> { order(:id) }
end
