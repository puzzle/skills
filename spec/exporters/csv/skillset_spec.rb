require 'rails_helper'

describe Csv::Skillset do
  context 'export' do
    it 'exports' do
      csv = Csv::Skillset.new(Skill.all).export
      csv = csv.split("\n")
      expect(csv.length).to eq(8)
      expect(csv.first.split(",").length).to eq(7)
      rails = csv.select { |s| s.include?('Rails') && s.include?('5') }.first
      expect(rails).not_to eq (nil)
      expect(rails).to include('Rails')
      expect(rails).to include('adopt')
      expect(rails).to include('aktiv')
      expect(rails).to include('Software-Engineering')
      expect(rails).to include('Ruby')
      expect(rails).to include('true')
      expect(rails).to include('5')
    end
  end
end
