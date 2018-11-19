# == Schema Information
#
# Table name: expertise_categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  discipline :integer          not null
#

require 'rails_helper'

describe ExpertiseCategory do
  context 'validations' do
    it 'checks whether required attribute values are present' do
      ec = ExpertiseCategory.new

      ec.valid?

      expect(ec.errors[:name].first).to eq('muss ausgefüllt werden')
      expect(ec.errors[:discipline].first).to eq('muss ausgefüllt werden')
      expect(ec.errors.details.count).to eq(2)
    end

    it 'checks if name is unique per discipline' do
      ec = ExpertiseCategory.new(name: 'ruby', discipline: 'development')

      ec.valid?

      expect(ec.errors[:name].first).to eq('ist bereits vergeben')
    end

    it 'checks name length' do
      ec = ExpertiseCategory.new(name: SecureRandom.hex(100))

      ec.valid?

      expect(ec.errors[:name].first).to eq('ist zu lang (mehr als 100 Zeichen)')
    end

    it 'checks if discipline is a valid value' do
      exception = assert_raises(ArgumentError) do
        ExpertiseCategory.new(discipline: 'wrong_value')
      end

      expect(exception.message).to eq("'wrong_value' is not a valid discipline")
    end
  end
end
