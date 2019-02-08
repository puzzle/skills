# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  updated_by  :string
#  description :text
#  title       :text
#  role        :text
#  technology  :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#  finish_at   :date
#  start_at    :date
#

include DaterangeSort
class Project < ApplicationRecord

  after_create :update_associations_updatet_at
  after_update :update_associations_updatet_at
  after_destroy :update_associations_updatet_at

  belongs_to :person, touch: true

  has_many :project_technologies, dependent: :destroy

  validates :start_at, :person_id, :role, :title, presence: true
  validates :description, :technology, :role, length: { maximum: 5000 }
  validates :title, length: { maximum: 500 }
  validate :start_at_before_finish_at
  validate :daterange_year_length

  scope :list, -> { sort(&by_daterange) }

  private

  def update_associations_updatet_at
    timestamp = Time.zone.now
    person.update!(associations_updatet_at: timestamp)
  end

end
