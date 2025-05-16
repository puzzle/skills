require 'rails_helper'

describe 'Projects', type: :feature, js:true do
  let(:person) { people(:bob) }

  before(:each) do
    sign_in auth_users(:admin)
    visit person_path(person)
  end

  describe 'Crud actions' do
    it 'shows all' do
      within('turbo-frame#project') do
        person.projects.each do |project|
          expect(page).to have_content(project.role)
          expect(page).to have_content(project.description)
          expect(page).to have_content(project.title)
          expect(page).to have_content(project.technology)
        end
      end
    end

    it 'creates and saves new project' do
      role = 'Pressure-washer dealer'
      description = 'Deals with pressure-washers'
      title = 'new title'
      technology = 'This technology'

      open_create_form(Project)

      within('turbo-frame#new_project') do
        select '2024', from: 'project_year_from'
        fill_in 'project_role', with: role
        fill_in 'project_description', with: description
        fill_in 'project_title', with: title
        fill_in 'project_technology', with: technology
        click_default_submit
      end


      expect(page).to have_content(role)
      expect(page).to have_content(description)
      expect(page).to have_content(title)
      expect(page).to have_content(technology)
    end

    it 'Create new with save & new' do
      role = "This is a new project with a role created by the save & new functionality"
      description = "This is a new project with a description created by the save & new functionality"
      title = "This is a new project with a title created by the save & new functionality"
      technology = "This is a new project with a technology created by the save & new functionality"

      open_create_form(Project)

      within('turbo-frame#new_project') do
        fill_in 'project_role', with: role
        fill_in 'project_description', with: description
        fill_in 'project_title', with: title
        fill_in 'project_technology', with: technology
        select 'Januar', from: 'project_month_from'
        select '2020', from: 'project_year_from'

        click_save_and_new_submit
      end
      expect(page).to have_content(role)
      expect(page).to have_content(description)
      expect(page).to have_content(title)
      expect(page).to have_content(technology)

      expect(page).to have_select('project_year_from', selected: "")
      expect(page).to have_select('project_month_from', selected: "-")
      expect(page).to have_field('project_role', with: "")
      expect(page).to have_field('project_description', with: "")
      expect(page).to have_field('project_title', with: "")
      expect(page).to have_field('project_technology', with: "")
    end

    it 'updates project' do
      updated_description = 'I am an updated description'
      project = person.projects.first

      open_edit_form(project)
      within("turbo-frame##{dom_id project}") do
        fill_in 'project_description', with: updated_description
        click_default_submit
      end
      expect(page).to have_content(updated_description)
    end

    it 'cancels without saving' do
      project = person.projects.first
      old_description = project.description
      updated_description = 'I like long descriptions'

      open_edit_form(project)
      within("turbo-frame##{dom_id project}") do
        fill_in 'project_description', with: updated_description
        find('a', text: 'Abbrechen').click
      end
      expect(page).to have_content(old_description)
    end

    it 'deletes project' do
      project = person.projects.first
      role = project.role
      open_edit_form(project)
      within("turbo-frame##{dom_id project}") do
        accept_confirm do
          click_link("Löschen")
        end
      end
      expect(page).not_to have_content(role)
    end
  end

  describe 'Error handling' do
    it 'create new project without role' do
      open_create_form(Project)

      within("turbo-frame##{dom_id Project.new}") do
        click_default_submit
      end
      expect(page).to have_css(".alert.alert-danger", text: "Rolle und Aufgaben muss ausgefüllt werden")
    end

    it 'Update entry and clear role' do
      project = person.projects.first
      open_edit_form(project)
      within("turbo-frame#project_#{project.id}") do
        fill_in 'project_role', with: ""
        click_default_submit
      end
      expect(page).to have_css(".alert.alert-danger", text: "Rolle und Aufgaben muss ausgefüllt werden")
    end

    it 'Update entry to not be displayed in the CV' do
      project = person.projects.first
      open_edit_form(project)
      checkbox = find('#project_display_in_cv')
      within("turbo-frame#project_#{project.id}") do
        checkbox.click
        click_default_submit
        expect(page).to have_css("img[src*='no-file']")
      end
      open_edit_form(project)
      expect(checkbox).not_to be_checked
    end
  end
end
