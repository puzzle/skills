# frozen_string_literal: true

# == Schema Information
#
# Table name: educations
#
#  id            :integer          not null, primary key
#  location      :text
#  title         :text
#  updated_at    :datetime
#  updated_by    :string
#  person_id     :integer
#  year_from     :integer          not null
#  year_to       :integer
#  month_from    :integer
#  month_to      :integer
#  display_in_cv :boolean


class Education < ApplicationRecord
  include DaterangeModel

  after_create :update_associations_updated_at
  after_update :update_associations_updated_at
  after_destroy :update_associations_updated_at

  belongs_to :person, touch: true

  validates :display_in_cv, inclusion: [true, false]
  validates :title, :location, presence: true
  validates :location, :title, length: { maximum: 500 }

  private

  def update_associations_updated_at
    timestamp = Time.zone.now
    person.update!(associations_updated_at: timestamp)
  end
end
