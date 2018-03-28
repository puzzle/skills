# == Schema Information
#
# Table name: employee_quantities
#
#  id                    :integer          not null, primary key
#  category              :string
#  quantity              :integer
#  company_id            :integer

require 'rails_helper'

describe EmployeeQuantity do
  context 'validations' do
    it 'checks presence of category' do
      et = EmployeeQuantity.new

      et.valid?

      expect(et.errors[:category].first).to eq('muss ausgefüllt werden')
    end
    
    it 'checks presence of quantity' do
      et = EmployeeQuantity.new

      et.valid?

      expect(et.errors[:quantity].first).to eq('muss ausgefüllt werden')
    end

    it 'checks length of category' do
      et = EmployeeQuantity.new(category: SecureRandom.hex(150))

      et.valid?

      expect(et.errors[:category].first).to eq('ist zu lang (mehr als 100 Zeichen)')
    end
    
    it 'checks positivity of quantity' do
      et = EmployeeQuantity.new(quantity: -1)

      et.valid?

      expect(et.errors[:quantity].first).to eq('muss größer oder gleich 0 sein')
    end
  end
end