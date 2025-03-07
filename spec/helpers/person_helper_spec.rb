require 'rails_helper'
RSpec.describe PersonHelper, type: :helper do

  describe '#fetch_people_data' do

    it 'should send request to ptime api' do
      allow(Skills).to receive(:use_ptime_sync?).and_return(true)
      skills_people = helper.fetch_people_data
      expected = [
        ["Longmax Smith", "/de/people/new?ptime_employee_id=33"],
        ["Alice Mante", "/de/people/new?ptime_employee_id=21"],
        ["Charlie Ford", "/de/people/new?ptime_employee_id=45"]
      ]
      expect(skills_people).to eq(expected)
    end

    it 'should return people from skills database if last request was right now' do
      allow(Skills).to receive(:use_ptime_sync?).and_return(false)

      skills_people = helper.fetch_people_data
      expected = [
        ["Bob Anderson", "/de/people/902541635", { class: "p-0", "data-html": "<a href='/de/people/902541635' class='dropdown-option-link'>Bob Anderson</a>" }],
        ["Alice Mante", "/de/people/663665735", { class: "p-0", "data-html": "<a href='/de/people/663665735' class='dropdown-option-link'>Alice Mante</a>" }],
        ["ken", "/de/people/155397742", { class: "p-0", "data-html": "<a href='/de/people/155397742' class='dropdown-option-link'>ken</a>" }],
        ["Charlie Ford", "/de/people/786122151", { class: "p-0", "data-html": "<a href='/de/people/786122151' class='dropdown-option-link'>Charlie Ford</a>" }],
        ["Wally Allround", "/de/people/790004949", { class: "p-0", "data-html": "<a href='/de/people/790004949' class='dropdown-option-link'>Wally Allround</a>" }],
        ["Hope Sunday", "/de/people/247095502", { class: "p-0", "data-html": "<a href='/de/people/247095502' class='dropdown-option-link'>Hope Sunday</a>" }],
        ["Longmax Smith", "/de/people/169654640", { class: "p-0", "data-html": "<a href='/de/people/169654640' class='dropdown-option-link'>Longmax Smith</a>" }]
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
