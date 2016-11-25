require 'rails_helper'

describe Competence do
  fixtures :competences

  context 'validations' do
    it 'checks whether presence is true' do
      competence = Competence.new
      competence.valid?

      expect(competence.errors[:person_id].first).to eq("can't be blank")
    end

    it 'max length should be 30' do
      competence = competences(:scrum)
      competence.updated_by = SecureRandom.hex(30)
      competence.valid?

      expect(competence.errors[:updated_by].first).to eq('is too long (maximum is 30 characters)')
    end

    it 'max length should be 1000' do
      competence = competences(:scrum)
      competence.description = SecureRandom.hex(1000)
      competence.valid?

      expect(competence.errors[:description].first).to eq('is too long (maximum is 1000 characters)')
    end
  end
end
