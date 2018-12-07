# == Schema Information
#
# Table name: advanced_trainings
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  person_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  finish_at   :date
#  start_at    :date
#

class AdvancedTraining < ApplicationRecord

  after_create :update_associations_updatet_at
  after_update :update_associations_updatet_at
  after_destroy :update_associations_updatet_at

  belongs_to :person, touch: true

  validates :start_at, :person_id, :description, presence: true
  validates :description, length: { maximum: 5000 }
  validate :start_at_before_finish_at

  scope :list, -> { order(Arel.sql('start_at IS NOT NULL, start_at desc, finish_at desc')) }

  private

  def update_associations_updatet_at
    timestamp = Time.zone.now
    person.update!(associations_updatet_at: timestamp)
  end

end
