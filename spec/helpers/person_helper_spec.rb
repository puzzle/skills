require 'rails_helper'
RSpec.describe PersonHelper, type: :helper do

  local_data = [
    ["Bob Anderson", "/people/902541635", { class: "p-0", "data-html": "<a href='/people/902541635' class='dropdown-option-link'>Bob Anderson</a>" }],
    ["Andreas Admin", "/people/135138680", { class: "p-0", "data-html": "<a href='/people/135138680' class='dropdown-option-link'>Andreas Admin</a>" }],
    ["Alice Mante", "/people/663665735", { class: "p-0", "data-html": "<a href='/people/663665735' class='dropdown-option-link'>Alice Mante</a>" }],
    ["ken", "/people/155397742", { class: "p-0", "data-html": "<a href='/people/155397742' class='dropdown-option-link'>ken</a>" }],
    ["Charlie Ford", "/people/786122151", { class: "p-0", "data-html": "<a href='/people/786122151' class='dropdown-option-link'>Charlie Ford</a>" }],
    ["Wally Allround", "/people/790004949", { class: "p-0", "data-html": "<a href='/people/790004949' class='dropdown-option-link'>Wally Allround</a>" }],
    ["Hope Sunday", "/people/247095502", { class: "p-0", "data-html": "<a href='/people/247095502' class='dropdown-option-link'>Hope Sunday</a>" }],
    ["Longmax Smith", "/people/169654640", { class: "p-0", "data-html": "<a href='/people/169654640' class='dropdown-option-link'>Longmax Smith</a>" }]
  ]

  ptime_data = [
    ["Longmax Smith", "/people/new?ptime_employee_id=33", { class: "p-0", "data-html": "<a href='/people/new?ptime_employee_id=33' class='dropdown-option-link'>Longmax Smith</a>" }],
    ["Alice Mante", "/people/new?ptime_employee_id=21", { class: "p-0", "data-html": "<a href='/people/new?ptime_employee_id=21' class='dropdown-option-link'>Alice Mante</a>" }],
    ["Charlie Ford", "/people/new?ptime_employee_id=45", { class: "p-0", "data-html": "<a href='/people/new?ptime_employee_id=45' class='dropdown-option-link'>Charlie Ford</a>" }]
  ]

  it 'should return people sorted alphabetically, ignoring case' do
    allow(Skills).to receive(:use_ptime_sync?).and_return(false)
    allow(helper).to receive(:fetch_local_people_data).and_return([
                                                                    ["bob", "/people/1", {}],
                                                                    ["Alice", "/people/2", {}],
                                                                    ["charlie", "/people/3", {}]
                                                                  ])

    sorted = helper.sorted_people.map(&:first)
    expect(sorted).to eq(["Alice", "bob", "charlie"])
  end

  it 'should return ptime data when ptime_sync is active' do
    allow(Skills).to receive(:use_ptime_sync?).and_return(true)
    skills_people = helper.fetch_people_data
    expect(skills_people).to match_array(ptime_data)
  end

  it 'should return local data when ptime_sync is inactive' do
    allow(Skills).to receive(:use_ptime_sync?).and_return(false)

    skills_people = helper.fetch_people_data
    expect(skills_people).to eq(local_data)
  end

  it 'should return local data when last PTime request has been less than an hour ago' do
    allow(Skills).to receive(:use_ptime_sync?).and_return(true)
    stub_env_var("LAST_PTIME_REQUEST", 30.minutes.ago.to_s)

    skills_people = helper.fetch_people_data
    expect(skills_people).to eq(local_data)
  end

  it 'should fall back to local data when PTime raises an error' do
    allow(Skills).to receive(:use_ptime_sync?).and_return(true)
    allow(helper).to receive(:fetch_ptime_people_data).and_raise(CustomExceptions::PTimeClientError)

    people = helper.fetch_people_data
    expect(people).to eq(local_data)
  end

  it 'should exclude unemployed employees from the dropdown' do
    allow(Skills).to receive(:use_ptime_sync?).and_return(true)
    ptime_employees = [
      { id: 1, attributes: { firstname: "John", lastname: "Doe", is_employed: true } },
      { id: 2, attributes: { firstname: "Jane", lastname: "Smith", is_employed: false } }
    ]
    allow_any_instance_of(Ptime::Client).to receive(:request).and_return(ptime_employees)

    people = helper.fetch_people_data
    expect(people.map(&:first)).to include("John Doe")
    expect(people.map(&:first)).not_to include("Jane Smith")
  end
end
