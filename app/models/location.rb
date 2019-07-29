# frozen_string_literal: true

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

class Location < ApplicationRecord

  # after_create :update_associations_updatet_at
  # after_update :update_associations_updatet_at
  # after_destroy :update_associations_updatet_at

  # The touch had to be removed because it caused deadlocks on travis
  # belongs_to :company, touch: true
  belongs_to :company

  validates :location, presence: true
  validates :location, length: { maximum: 100 }

  # private

  # def update_associations_updatet_at
  #   timestamp = Time.zone.now
  #   company.update!(associations_updatet_at: timestamp)
  # end

end
