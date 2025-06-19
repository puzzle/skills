# frozen_string_literal: true

# == Schema Information
#
#  Table name: educations
#
#  id             :integer          not null, primary key
#  title          :string
#  reference      :string
#  person_id      :integer
#  year_from      :integer
#  year_to        :integer
#  month_from     :integer
#  month_to       :integer
#  display_in_cv  :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null

class Contribution < ApplicationRecord
  include DaterangeModel

  after_create :update_associations_updatet_at
  after_update :update_associations_updatet_at
  after_destroy :update_associations_updatet_at

  belongs_to :person, touch: true

  validates :display_in_cv, inclusion: [false]
  validates :title, presence: true

  private

  def update_associations_updatet_at
    timestamp = Time.zone.now
    person.update!(associations_updatet_at: timestamp)
  end
end
