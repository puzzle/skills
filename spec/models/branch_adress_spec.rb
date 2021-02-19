require 'rails_helper'

RSpec.describe BranchAdress, type: :model do
  context 'validations' do

    it 'check whether required attributes are present' do
      branch = BranchAdress.new
      branch.valid?

      expect(branch.errors[:short_name].first).to eq('muss ausgefüllt werden')
      expect(branch.errors[:country].first).to eq('muss ausgefüllt werden')
      expect(branch.errors[:adress_information].first).to eq('muss ausgefüllt werden')
    end

    it 'should not be more than 200 characters' do
      branch = BranchAdress.new
      branch.short_name = "Test"
      branch.country = "CH"
      branch.default_branch_adress = false
      branch.adress_information = SecureRandom.hex(201)

      branch.valid?

      expect(branch.errors[:adress_information].first).to eq('ist zu lang (mehr als 200 Zeichen)')
    end
  end
end
