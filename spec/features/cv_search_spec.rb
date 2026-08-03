require 'rails_helper'

describe 'Advanced Trainings', type: :feature, js: true do
  let(:bob) { people(:bob) }
  let(:alice) { people(:alice) }

  before do
    sign_in auth_users(:admin)
    visit("/cv_search")
  end

  describe 'Search' do
    [
      { search_term: ->(p) { p.name }, found_in: :name },
      { search_term: ->(p) { p.projects.first.technology }, found_in: :projects },
      { search_term: ->(p) { p.title }, found_in: :title },
      { search_term: ->(p) { p.roles.first.name }, found_in: :roles },
      { search_term: ->(p) { p.department.name }, found_in: :department },
      { search_term: ->(p) { p.competence_notes.split.first }, found_in: :competence_notes },
      { search_term: ->(p) { p.advanced_trainings.first.description }, found_in: :advanced_trainings },
      { search_term: ->(p) { p.educations.first.location }, found_in: :educations },
      { search_term: ->(p) { p.activities.first.description }, found_in: :activities },
      { search_term: ->(p) { p.projects.first.description }, found_in: :projects }
    ].each do |data|
      it "should find correct results for #{data[:found_in]}" do
        search_term = data[:search_term].call(bob)
        perform_search(search_term)

        check_search_results(Person.human_attribute_name(data[:found_in]))
      end
    end

    [
      { search_term: ->(p) { p.projects.first.technology }, found_in: :projects },
      { search_term: ->(p) { p.educations.first.location }, found_in: :educations }
    ].each do |data|
      it "should open person when clicking #{data[:found_in]} result" do
        search_term = data[:search_term].call(bob)
        human_name = Person.human_attribute_name(data[:found_in])

        perform_search(search_term)
        check_search_results(human_name)

        click_link(human_name)

        expect(page).to have_current_path(person_path(bob, q: search_term, section_id: data[:found_in].to_s))
      end
    end

    it 'should only display results when length of search-text is > 3' do
      perform_search(bob.name.slice(0, 2))
      expect(page).not_to have_content(bob.name)
      expect(page).to have_content("Du musst mindestens 3 Zeichen eingeben.")

      perform_search(bob.name.slice(0, 3))
      expect(page).to have_content(bob.name)
    end

    it 'should dynamically search skills' do
      skill_title = bob.skills.last.title
      perform_search(skill_title)
      page.check('search_skills')

      check_search_results(Skill.model_name.human.pluralize)
      expect(page).to have_link(href: /#{person_people_skills_path(bob)}.*q=#{skill_title}/)
    end

    it 'should dynamically search with whitespace handling enabled' do
      perform_search("B o b")
      page.check('handle_whitespaces')

      expect(page).to have_content(bob.name)
      check_search_results(Person.human_attribute_name(:name))

      click_link "Name"
      expect(page).to have_link(href: person_path(bob, q: "Bob Anderson", section_id: "personal-data"))
    end

    it "should disable whitespace handling if there are no whitespaces in search" do
      perform_search("Ruby")
      expect(page).to have_field('handle_whitespaces', disabled: true)
    end

    it "should highlight the correct text" do
      first_name = bob.name.split(' ').first
      perform_search(first_name)

      expect(page).to have_link("Name")
      click_link "Name"

      expect(page).to have_current_path(person_path(bob, q: bob.name, section_id: "personal-data"))

      within("#personal-data") do
        expect(page).to have_selector('mark.highlight', text: first_name)
      end
    end

    it 'should show multiple found skills and with category' do
      first_skill = 'Java'
      second_skill = 'Javascript'

      visit skills_path
      rename_skill_with(first_skill, Skill.first)
      rename_skill_with(second_skill, Skill.fourth, 'System-Engineering')

      visit cv_search_index_path

      perform_search(first_skill)
      check 'search_skills'

      expected_url = /#{person_people_skills_path(alice)}.*q=#{first_skill}/
      expect(page).to have_link(href: expected_url)

      skills_label = Skill.model_name.human.pluralize
      check_search_results("#{skills_label}/ #{alice.skills.first.parent_category.title}", alice)
    end
  end

  private

  def perform_search(term)
    fill_in 'cv_search_field', with: term
  end

  def check_search_results(field_name, person = bob)
    within('turbo-frame#search-results') do
      expect(page).to have_link(person.name)
      expect(page).to have_link(field_name)
    end
  end

  def rename_skill_with(name, skill, category = 'Software-Engineering')
    within("#skill_#{skill.id}") do
      find('.icon.icon-pencil').click
      fill_in 'skill_title', with: name
      select category, from: 'skill_category_parent'
      find("input[type='image']").click
    end
  end
end
