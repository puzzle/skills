# == Schema Information
#
# Table name: locations
#
#  id                    :integer          not null, primary key
#  location              :string
#  company_id            :integer

class Location < ApplicationRecord

  after_create :update_associations_updatet_at
  after_update :update_associations_updatet_at
  after_destroy :update_associations_updatet_at

  belongs_to :company, touch: true

  validates :location, presence: true
  validates :location, length: { maximum: 100 }

  private

  def update_associations_updatet_at
    timestamp = Time.zone.now
    company.update!(associations_updatet_at: timestamp)
  end

end
