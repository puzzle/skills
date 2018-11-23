require 'rails_helper'

describe Role do
  context 'validations' do
    it 'should not be more than 100 characters' do
      role = Role.new
      role.name = SecureRandom.hex(150)
      role.valid?

      expect(role.errors[:name].first).to eq('ist zu lang (mehr als 100 Zeichen)')
    end
  end

end
