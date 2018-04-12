# == Schema Information
#
# Table name: companies
#
#  id                    :integer          not null, primary key
#  name                  :string
#  web                   :string
#  email                 :string
#  phone                 :string
#  partnermanager        :string
#  contact_person        :string
#  email_contact_person  :string
#  phone_contact_person  :string
#  crm                   :string
#  level                 :string
#  picture               :string
#  my_company            :boolean, default: false

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
        company.web = SecureRandom.hex(150)
        company.email = SecureRandom.hex(150)
        company.phone = SecureRandom.hex(150)
        company.partnermanager = SecureRandom.hex(150)
        company.contact_person = SecureRandom.hex(150)
        company.email_contact_person = SecureRandom.hex(150)
        company.phone_contact_person = SecureRandom.hex(150)
        company.crm = SecureRandom.hex(150)
        company.level = SecureRandom.hex(150)
        company.valid?

        expect(company.errors[:name].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(company.errors[:web].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(company.errors[:email].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(company.errors[:phone].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(company.errors[:partnermanager].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(company.errors[:contact_person].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(company.errors[:email_contact_person].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(company.errors[:phone_contact_person].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(company.errors[:crm].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(company.errors[:level].first).to eq('ist zu lang (mehr als 100 Zeichen)')
      end
    end
end
