# == Schema Information
#
# Table name: statuses
#
#  id     :integer          not null, primary key
#  status :string
#

class Status < ApplicationRecord
  has_many :people

  scope :list, -> { order(:status) }
end
