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
#  year_from   :integer
#  year_to     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#

class Project < ApplicationRecord
  
  after_create :update_associations_updatet_at
  after_update :update_associations_updatet_at
  after_destroy :update_associations_updatet_at

  belongs_to :person, touch: true

  has_many :project_technologies, dependent: :destroy

  validates :year_from, :person_id, :role, :title, presence: true
  validates :year_from, :year_to, length: { is: 4 }, allow_blank: true
  validates :description, :technology, :role, length: { maximum: 5000 }
  validates :title, length: { maximum: 500 }
  validate :year_from_before_year_to

  scope :list, -> { order('year_to IS NOT NULL, year_from desc, year_to desc') }

  private

  def update_associations_updatet_at
  	timestamp = DateTime.now
    self.person.update!(associations_updatet_at: timestamp)
  end

end
