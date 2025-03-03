require 'rails_helper'
RSpec.describe PersonHelper, type: :helper do

  describe '#fetch_ptime_or_skills_data' do

    it 'should send request to ptime api' do
      allow(Skills).to receive(:ptime_available?).and_return(true)
      skills_people = helper.fetch_people_data
      expected = [
        ["Longmax Smith", "/de/people/new?ptime_employee_id=33"],
        ["Alice Mante", "/de/people/new?ptime_employee_id=21"],
        ["Charlie Ford", "/de/people/new?ptime_employee_id=45"]
      ]
      expect(skills_people).to eq(expected)
    end

    it 'should return people from skills database if last request was right now' do
      allow(Skills).to receive(:ptime_available?).and_return(false)

      skills_people = helper.fetch_people_data
      expected = [
        ["Bob Anderson", "/de/people/902541635"],
        ["Alice Mante", "/de/people/663665735"],
        ["ken", "/de/people/155397742"],
        ["Charlie Ford", "/de/people/786122151"],
        ["Wally Allround", "/de/people/790004949"],
        ["Hope Sunday", "/de/people/247095502"],
        ["Longmax Smith", "/de/people/169654640"]
      ]
      expect(skills_people).to eq(expected)
    end
  end

  describe '#build_dropdown_data' do
    it 'should build correct dropdown data' do
      longmax = people(:longmax)
      alice = people(:alice)
      people(:charlie)

      longmax.update!(ptime_employee_id: 33)
      alice.update!(ptime_employee_id: 21)

      dropdown_data = build_people_dropdown(ptime_employees_data)
      expected = [
        ["Longmax Smith", "/de/people/169654640"],
        ["Alice Mante", "/de/people/663665735"],
        ["Charlie Ford", "/de/people/new?ptime_employee_id=45"]]
      expect(dropdown_data).to eq(expected)

    end
  end
end
