require 'rails_helper'

describe ErrorSerializer do
  context 'serialize' do
    it 'serializes errors' do
      p = Person.new
      p.valid?

      json = ErrorSerializer.serialize(p.errors)

      expect(json).to include(:errors)
      expect(json).to include(:id)
      expect(json).to include(:title)
      expect(json[:errors].first[:id]).to eq(:department)
      expect(json[:errors].first[:title]).to eq('Department muss ausgefüllt werden')
      expect(json[:errors].second[:id]).to eq(:birthdate)
      expect(json[:errors].second[:title]).to eq('Birthdate muss ausgefüllt werden')
    end
  end
end
