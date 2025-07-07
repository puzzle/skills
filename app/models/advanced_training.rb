# frozen_string_literal: true

# == Schema Information
#
# Table name: advanced_trainings
#
#  id           :integer          not null, primary key
#  description  :text
#  updated_by   :string
#  person_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  year_from    :integer          not null
#  year_to      :integer
#  month_from   :integer
#  month_to     :integer
# display_in_cv :boolean
#

class AdvancedTraining < ApplicationRecord
  include DaterangeModel

  attr_readonly :person_id
  after_create :update_associations_updated_at
  after_update :update_associations_updated_at
  after_destroy :update_associations_updated_at

  belongs_to :person, touch: true

  validates :display_in_cv, inclusion: [true, false]
  validates :description, presence: true
  validates :description, length: { maximum: 5000 }

  scope :list, lambda {
    order('
    year_to DESC NULLS FIRST,
    year_from DESC,
    month_to DESC NULLS FIRST,
    month_from DESC NULLS FIRST')
  }

  private

  def update_associations_updated_at
    timestamp = Time.zone.now
    person.update!(associations_updated_at: timestamp)
  end

end
