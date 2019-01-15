# == Schema Information
#
# Table name: educations
#
#  id         :integer          not null, primary key
#  location   :text
#  title      :text
#  updated_at :datetime
#  updated_by :string
#  person_id  :integer
#  finish_at  :date
#  start_at   :date
#
include DaterangeSort
class Education < ApplicationRecord

  after_create :update_associations_updatet_at
  after_update :update_associations_updatet_at
  after_destroy :update_associations_updatet_at

  belongs_to :person, touch: true

  validates :start_at, :person_id, :title, :location, presence: true
  validates :location, :title, length: { maximum: 500 }
  validate :start_at_before_finish_at

  scope :list, -> { sort(&by_daterange) }

  private

  def update_associations_updatet_at
    timestamp = Time.zone.now
    person.update!(associations_updatet_at: timestamp)
  end
end
