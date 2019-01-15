# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  role        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#  finish_at   :date
#  start_at    :date
#

include DaterangeSort
class Activity < ApplicationRecord

  after_create :update_associations_updatet_at
  after_update :update_associations_updatet_at
  after_destroy :update_associations_updatet_at

  belongs_to :person, touch: true

  validates :start_at, :person_id, :role, presence: true
  validates :description, length: { maximum: 5000 }
  validates :role, length: { maximum: 500 }
  validate :start_at_before_finish_at

  scope :list, -> { sort(&by_daterange) }

  private

  def update_associations_updatet_at
    timestamp = Time.zone.now
    person.update!(associations_updatet_at: timestamp)
  end

end
