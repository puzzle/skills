require 'rails_helper'
RSpec.describe PersonHelper, type: :helper do

  describe '#fetch_ptime_or_skills_data' do

    it 'should send request to ptime api' do
      fetch_ptime_or_skills_data
    end

    it 'should return people from skills database if last request was right now' do
      ENV['LAST_PTIME_API_REQUEST'] = DateTime.current.to_s
      skills_people = fetch_ptime_or_skills_data
      expect(skills_people).to eq(Person.all)
    end
  end

  describe '#build_dropdown_data' do
    it 'should build correct dropdown data' do
      longmax = people(:longmax)
      alice = people(:alice)
      charlie = people(:charlie)

      longmax.update!(ptime_employee_id: 33)
      alice.update!(ptime_employee_id: 21)
      charlie.update!(ptime_employee_id: 45)

      parsed_employees = JSON.parse(return_ptime_employees_json)
      dropdown_data = build_dropdown_data(parsed_employees['data'], Person.all.pluck(:ptime_employee_id))

      expect(dropdown_data[0][:id]).to eq(longmax.id)
      expect(dropdown_data[0][:ptime_employee_id]).to eq(longmax.ptime_employee_id)
      expect(dropdown_data[0][:name]).to eq("Longmax Smith")
      expect(dropdown_data[0][:already_exists]).to be(true)

      expect(dropdown_data[1][:id]).to eq(alice.id)
      expect(dropdown_data[1][:ptime_employee_id]).to eq(alice.ptime_employee_id)
      expect(dropdown_data[1][:name]).to eq("Alice Mante")
      expect(dropdown_data[1][:already_exists]).to be(true)

      expect(dropdown_data[2][:id]).to eq(charlie.id)
      expect(dropdown_data[2][:ptime_employee_id]).to eq(charlie.ptime_employee_id)
      expect(dropdown_data[2][:name]).to eq("Charlie Ford")
      expect(dropdown_data[2][:already_exists]).to be(true)
    end
  end
end
