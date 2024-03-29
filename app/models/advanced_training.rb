# frozen_string_literal: true

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
#  year_from   :integer          not null
#  year_to     :integer
#  month_from  :integer
#  month_to    :integer
#

class AdvancedTraining < ApplicationRecord
  include DaterangeModel

  after_create :update_associations_updatet_at
  after_update :update_associations_updatet_at
  after_destroy :update_associations_updatet_at

  belongs_to :person, touch: true

  validates :description, presence: true
  validates :description, length: { maximum: 5000 }

  private

  def update_associations_updatet_at
    timestamp = Time.zone.now
    person.update!(associations_updatet_at: timestamp)
  end

end
