# == Schema Information
#
# Table name: person_competence
#
#  id                    :integer          not null, primary key
#  category              :string
#  offer                 :array
#  person_id            :integer

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
