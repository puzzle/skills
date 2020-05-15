# == Schema Information
#
# Table name: companies
#
#  id                      :bigint(8)        not null, primary key
#  name                    :string

require 'rails_helper'


describe Company do

    context 'validations' do
      it 'checks whether required attribute values are present' do
        company = Company.new
        company.valid?

        expect(company.errors[:name].first).to eq('muss ausgefüllt werden')
      end

      it 'should not be more than 100 characters' do
        company = Company.new
        company.name = SecureRandom.hex(150)
        company.valid?

        expect(company.errors[:name].first).to eq('ist zu lang (mehr als 100 Zeichen)')
      end
    end
end
