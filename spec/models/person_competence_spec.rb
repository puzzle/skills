# == Schema Information
#
# Table name: person_competences
#
#  id         :bigint(8)        not null, primary key
#  category   :string
#  offer      :text             default([]), is an Array
#  person_id  :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'


describe PersonCompetence do

    context 'validations' do
      it 'checks whether required attribute values are present' do
        person_competence = PersonCompetence.new
        person_competence.valid?

        expect(person_competence.errors[:category].first).to eq('muss ausgefüllt werden')
      end

      it 'should not be more than 100 characters' do
        person_competence = PersonCompetence.new
        person_competence.category = SecureRandom.hex(150)
        person_competence.valid?

        expect(person_competence.errors[:category].first).to eq('ist zu lang (mehr als 100 Zeichen)')
      end
    end
end
