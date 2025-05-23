require 'rails_helper'

describe ErrorSerializer do
  context 'serialize' do
    it 'serializes errors' do
      p = Person.new
      p.valid?

      json = ErrorSerializer.serialize(p.errors)

      expect(json).to include(:errors)
      expect(json[:errors].first).to include(:id)
      expect(json[:errors].first).to include(:title)
      expect(json[:errors].first[:id]).to eq(:company)
      expect(json[:errors].first[:title]).to eq('Firma muss ausgefüllt werden')
      expect(json[:errors].second[:id]).to eq(:location)
      expect(json[:errors].second[:title]).to eq('Ort muss ausgefüllt werden')
    end
  end
end
