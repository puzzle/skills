require 'rails_helper'

describe Competence do
  fixtures :competences

  context 'validations' do
    it 'checks whether required attribute values are present' do
      competence = Competence.new
      competence.valid?

      expect(competence.errors[:person_id].first).to eq("can't be blank")
    end

    it 'should not be more than 1000 characters in the description' do
      competence = competences(:scrum)
      competence.description = SecureRandom.hex(1000)
      competence.valid?

      expect(competence.errors[:description].first).to eq('is too long (maximum is 1000 characters)')
    end
  end
end
