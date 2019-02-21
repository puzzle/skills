# == Schema Information
#
# Table name: people_roles
#
#  id        :bigint(8)        not null, primary key
#  person_id :bigint(8)
#  role_id   :bigint(8)
#  level     :string
#  percent   :decimal(5, 2)
#

require 'rails_helper'

describe PeopleRole do
  fixtures :people_roles

  context 'validations' do
    it 'checks whether required attribute values are present' do
      people_role = PeopleRole.new
      people_role.valid?

      expect(people_role.errors[:person].first).to eq('muss ausgefüllt werden')
      expect(people_role.errors[:role].first).to eq('muss ausgefüllt werden')
      expect(people_role.errors[:person_id].first).to eq('muss ausgefüllt werden')
      expect(people_role.errors[:role_id].first).to eq('muss ausgefüllt werden')
      expect(people_role.errors[:level].first).to eq('muss ausgefüllt werden')
      expect(people_role.errors[:percent].first).to eq('muss ausgefüllt werden')
    end
    
    it 'percent must be a number between 0 and 200' do
      people_role = people_roles(:'people-role1')
      people_role.percent = 300
      people_role.valid?

      expect(people_role.errors[:percent].first).to eq('muss zwischen 0 und 200 sein')
    end
  end
end
