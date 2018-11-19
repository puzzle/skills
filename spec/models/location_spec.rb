# == Schema Information
#
# Table name: locations
#
#  id         :bigint(8)        not null, primary key
#  location   :string
#  company_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Location do
  context 'validations' do
    it 'checks presence of location' do
      et = Location.new

      et.valid?

      expect(et.errors[:location].first).to eq('muss ausgefüllt werden')
    end

    it 'checks length of location' do
      et = Location.new(location: SecureRandom.hex(150))

      et.valid?

      expect(et.errors[:location].first).to eq('ist zu lang (mehr als 100 Zeichen)')
    end
  end
end
