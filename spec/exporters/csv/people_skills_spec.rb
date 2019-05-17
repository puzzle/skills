require 'rails_helper'

describe Csv::PeopleSkills do
  fixtures :people

  context 'export' do
    it 'exports' do
      people_skills = people(:bob).people_skills
      csv = Csv::PeopleSkills.new(people_skills).export
      csv = csv.split("\n")
      expect(csv.length).to eq(4)
      expect(csv.first.split(",").length).to eq(7)
      rails = csv.select { |s| s.include?('Rails') && s.include?('5') }.first
      expect(rails).not_to eq (nil)
      expect(rails).to include('Software-Engineering')
      expect(rails).to include('Ruby')
      expect(rails).to include('5')
      expect(rails).to include('3')
      expect(rails).to include('false')
      expect(rails).to include('true')
    end
  end
end
