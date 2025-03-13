require 'rails_helper'
RSpec.describe PersonHelper, type: :helper do

  describe '#fetch_people_data' do

    it 'should send request to ptime api' do
      allow(Skills).to receive(:use_ptime_sync?).and_return(true)
      skills_people = helper.fetch_people_data
      expected = [
        ["Longmax Smith", "/people/new?ptime_employee_id=33", { class: "p-0", "data-html": "<a href='/people/new?ptime_employee_id=33' class='dropdown-option-link'>Longmax Smith</a>" }],
        ["Alice Mante", "/people/new?ptime_employee_id=21", { class: "p-0", "data-html": "<a href='/people/new?ptime_employee_id=21' class='dropdown-option-link'>Alice Mante</a>" }],
        ["Charlie Ford", "/people/new?ptime_employee_id=45", { class: "p-0", "data-html": "<a href='/people/new?ptime_employee_id=45' class='dropdown-option-link'>Charlie Ford</a>" }]
      ]
      expect(skills_people).to eq(expected)
    end

    it 'should return people from skills database if last request was right now' do
      allow(Skills).to receive(:use_ptime_sync?).and_return(false)

      skills_people = helper.fetch_people_data
      expected = [
        ["Bob Anderson", "/people/902541635", { class: "p-0", "data-html": "<a href='/people/902541635' class='dropdown-option-link'>Bob Anderson</a>" }],
        ["Alice Mante", "/people/663665735", { class: "p-0", "data-html": "<a href='/people/663665735' class='dropdown-option-link'>Alice Mante</a>" }],
        ["ken", "/people/155397742", { class: "p-0", "data-html": "<a href='/people/155397742' class='dropdown-option-link'>ken</a>" }],
        ["Charlie Ford", "/people/786122151", { class: "p-0", "data-html": "<a href='/people/786122151' class='dropdown-option-link'>Charlie Ford</a>" }],
        ["Wally Allround", "/people/790004949", { class: "p-0", "data-html": "<a href='/people/790004949' class='dropdown-option-link'>Wally Allround</a>" }],
        ["Hope Sunday", "/people/247095502", { class: "p-0", "data-html": "<a href='/people/247095502' class='dropdown-option-link'>Hope Sunday</a>" }],
        ["Longmax Smith", "/people/169654640", { class: "p-0", "data-html": "<a href='/people/169654640' class='dropdown-option-link'>Longmax Smith</a>" }]
      ]
      expect(skills_people).to eq(expected)
    end
  end
end
