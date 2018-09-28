# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  role        :text
#  year_from   :integer
#  year_to     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#

class Activity < ApplicationRecord

  after_create :update_associations_updatet_at
  after_update :update_associations_updatet_at
  after_destroy :update_associations_updatet_at

  belongs_to :person, touch: true

  validates :year_from, :person_id, :role, presence: true
  validates :year_from, :year_to, length: { is: 4 }, allow_blank: true
  validates :description, length: { maximum: 5000 }
  validates :role, length: { maximum: 500 }
  validate :year_from_before_year_to

  scope :list, -> { order('year_to IS NOT NULL, year_from desc, year_to desc') }

  private

  def update_associations_updatet_at
    timestamp = DateTime.now
    person.update!(associations_updatet_at: timestamp)
  end

end
