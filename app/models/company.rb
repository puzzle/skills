# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
#
#  id                      :bigint(8)        not null, primary key
#  name                    :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Company < ApplicationRecord
  has_many :people, dependent: :nullify

  validates :name, presence: true
  validates :name, length: { maximum: 100 }

  scope :list, -> { order('name asc') }
end
