# == Schema Information
#
# Table name: person_roles
#
#  id        :bigint(8)        not null, primary key
#  person_id :bigint(8)
#  role_id   :bigint(8)
#  level     :string
#  percent   :decimal(5, 2)
#

require 'rails_helper'

describe PersonRole do
  fixtures :person_roles

  context 'validations' do
    it 'checks whether required attribute values are present' do
      person_role = PersonRole.new
      person_role.valid?

      expect(person_role.errors[:person].first).to eq('muss ausgefüllt werden')
      expect(person_role.errors[:role].first).to eq('muss ausgefüllt werden')
    end

    it 'percent must be a number between 0 and 200' do
      person_role = person_roles(:'bob_software_engineer')
      person_role.percent = 300
      person_role.valid?

      expect(person_role.errors[:percent].first).to eq('muss zwischen 0 und 200 sein')
    end
  end
end
