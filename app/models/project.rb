# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  updated_by    :string
#  description   :text
#  title         :text
#  role          :text
#  technology    :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  person_id     :integer
#  year_from     :integer          not null
#  year_to       :integer
#  month_from    :integer
#  month_to      :integer
#  display_in_cv :boolean

class Project < ApplicationRecord
  include DaterangeModel

  after_create :update_associations_updated_at
  after_update :update_associations_updated_at
  after_destroy :update_associations_updated_at

  belongs_to :person, touch: true

  has_many :project_technologies, dependent: :destroy

  validates :display_in_cv, inclusion: [true, false]
  validates :role, :title, presence: true
  validates :description, :technology, :role, length: { maximum: 5000 }
  validates :title, length: { maximum: 500 }

  private

  def update_associations_updated_at
    timestamp = Time.zone.now
    person.update!(associations_updated_at: timestamp)
  end

end
