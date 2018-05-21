# == Schema Information
#
# Table name: person_competences
#
#  id                    :integer          not null, primary key
#  category              :string
#  offer                 :array
#  person_id            :integer

class PersonCompetence < ApplicationRecord
  
  after_create :update_associations_updatet_at
  after_update :update_associations_updatet_at
  after_destroy :update_associations_updatet_at

  belongs_to :person
  
  validates :category, presence: true
  validates :category, length: { maximum: 100 }

  private

  def update_associations_updatet_at
  	timestamp = DateTime.now
    self.person.update!(associations_updatet_at: timestamp)
  end

end
