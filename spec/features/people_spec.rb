require 'rails_helper'

describe :people do
  describe 'People Search', type: :feature, js: true do

    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    let(:people_list) {Person.all}

    it 'displays people in alphabetical order in select' do
      visit people_path
      dropdown_options = people_list.pluck(:name).sort_by(&:downcase)
      dropdown_options.unshift("Bitte wählen")
      ss_check_options("#person_id_person", dropdown_options)
    end

    it 'redirects to the selected person on change' do
      visit people_path
      bob = people(:bob)
      select_from_slim_select("#person_id_person", bob.name)
      expect(page).to have_current_path(person_path(bob))
    end

    it 'redirect to the first entry' do
      visit people_path
      sorted_list = people_list.sort_by { |item| item.name.downcase }
      ss_select_index("#person_id_person", 1)
      expect(page).to have_current_path(person_path(sorted_list.first.id))
    end

    it 'should only display matched people' do
      visit people_path
      sorted_list = people_list.sort_by { |item| item.name.downcase }
      search_string = "al"
      page.find('.ss-main').click
      page.all('input')[0].send_keys(search_string)

      matched_strings, not_matched_strings = sorted_list.partition do |person|
        person.name.downcase.include?(search_string)
      end

      matched_strings.pluck(:name).each do |name|
        expect(page).to have_text(name)
      end

      not_matched_strings.pluck(:name).each do |name|
        expect(page).to have_no_text(name)
      end
    end
  end

  def common_languages_translated
    I18nData.languages('DE').collect do |language|
      if LanguageList::LanguageInfo.find(language[0])&.common?
        [language.first, "#{language.last} (#{language.first})"]
      end
    end.compact.sort_by(&:last)
  end


  def fill_out_person_form
    page.attach_file("avatar-uploader", Rails.root + 'app/assets/images/anonymous_profile_picture.png')
    fill_in 'person_name', with: 'Hansjakobli'
    fill_in 'person_email', with: 'hanswurst@somemail.com'
    fill_in 'person_title', with: 'Wurstexperte'
    page.first(".add_fields").click
    role_select = page.all('.role-select').last
    role_level_select = page.all('.role-level-select').last
    role_percent_select = page.all('.person-role-percent').last
    select 'System-Engineer', from: role_select[:id]
    select 'S3', from: role_level_select[:id]
    fill_in role_percent_select[:id], with: '80'

    select '/ux', from: 'person_department_id'
    select 'Partner', from: 'person_company_id'
    fill_in 'person_location', with: 'Las Vegas'
    fill_in 'person_birthdate', with: '1979-03-28'.to_date
    check 'nat-two-checkbox'
    select ISO3166::Country["DE"].translations[I18n.locale], from: 'person_nationality'
    select ISO3166::Country["US"].translations[I18n.locale], from: 'person_nationality2'
    select t('marital_statuses.married'), from: 'person_marital_status'
    fill_in 'person_shortname', with: 'bb'

    page.all(".add_fields").last.click
    language_select = page.all('.language-select').last
    language_level_select = page.all('.language-level-select').last
    language_certificate_input = page.all('.language-certificate-input').last
    select 'FI', from: language_select[:id]
    select 'B2', from: language_level_select[:id]
    fill_in language_certificate_input[:id], with: 'Some Certificate'
  end

  def assert_form_persisted(old_number_of_roles)
    expect(page).to have_content("Hansjakobli")

    person = Person.find_by(name: 'Hansjakobli')
    expect(person.picture.identifier).to eql('anonymous_profile_picture.png')
    expect(person.email).to eql('hanswurst@somemail.com')
    expect(person.title).to eql('Wurstexperte')
    expect(person.person_roles.count).to eql(old_number_of_roles + 1)
    edited_person_role = person.person_roles.last
    expect(edited_person_role.role.name).to eql('System-Engineer')
    expect(edited_person_role.person_role_level.level).to eql('S3')
    expect(edited_person_role.percent).to eq(80)
    expect(person.department.name).to eql('/ux')
    expect(person.company.name).to eql('Partner')
    expect(person.location).to eql('Las Vegas')
    expect(person.birthdate.to_date.strftime('%d.%m.%Y')).to eql('28.03.1979')
    expect(person.nationality).to eql('DE')
    expect(person.nationality2).to eql('US')
    expect(person.marital_status).to eql('married')
    expect(person.shortname).to eql('bb')
    edited_language_skill = person.language_skills.last
    expect(edited_language_skill.language).to eql('FI')
    expect(edited_language_skill.level).to eql('B2')
    expect(edited_language_skill.certificate).to eql('Some Certificate')
  end

  def check_edit_fields(person, editing)
    expect(page).to have_field('avatar-uploader')
    expect(page).to have_field('person_name', with: person.name)
    expect(page).to have_field('person_email', with: person.email)
    expect(page).to have_field('person_title', with: person.title)
    person_roles = person.person_roles
    role_selects = page.all('.role-select')
    role_level_selects = page.all('.role-level-select')
    role_percent_selects = page.all('.person-role-percent')
    expect(role_selects.count).to equal(person_roles.count)
    expect(role_level_selects.count).to equal(person_roles.count)
    expect(role_percent_selects.count).to equal(person_roles.count)
    role_selects.each_with_index do |role_select, i|
      expect(role_select.value.to_i).to equal(person_roles[i].role_id)
    end
    role_level_selects.each_with_index do |role_level_select, i|
      person_roles[i].person_role_level_id.nil? ? (expect(role_level_select.value.to_i).to equal(PersonRoleLevel.first.id)) : (expect(role_level_select.value.to_i).to equal(person_roles[i].person_role_level_id))
    end
    role_percent_selects.each_with_index do |role_percent_select, i|
      expect(role_percent_select.value.to_i).to equal(person_roles[i].percent.to_i)
    end
    expect(page).to have_select('person_department_id', selected: person.department.nil? ? Department.order(:name).first&.name : person.department.name)
    expect(page).to have_select('person_company_id', selected: person.company.nil? ? Company.order(:name).first&.name : person.company.name)
    expect(page).to have_field('person_location', with: person.location)
    expect(page).to have_field('person_birthdate', with: person.birthdate&.to_date&.strftime)
    if person.nationality2.nil?
      expect(find_field('nat-two-checkbox')).not_to be_checked
    else
      expect(find_field('nat-two-checkbox')).to be_checked
    end
    expect(page.all('.nationality-two').count).to equal(person.nationality2.nil? ? 0 : 2)
    expect(page).to have_select('person_nationality', selected: person.nationality.nil? ? ISO3166::Country[:CH].translations[I18n.locale] : ISO3166::Country[person.nationality].translations[I18n.locale])
    person.nationality2.nil? ? (expect(page).not_to have_select('person_nationality2')) : (expect(page).to have_select('person_nationality2', selected: ISO3166::Country[person.nationality2].translations[I18n.locale]))
    expect(page).to have_select('person_marital_status', selected: t("marital_statuses.#{person.marital_status}"))
    expect(page).to have_field('person_shortname', with: person.shortname)

    language_skills = person.language_skills
    language_selects = page.all('.language-select')
    language_level_selects = page.all('.language-level-select')
    language_certificate_inputs = page.all('.language-certificate-input')
    if editing
      language_selects.each_with_index do |language_select, i|
        expect(language_select.value).to eql(language_skills[i].language)
      end
      language_level_selects.each_with_index do |language_level_select, i|
        expect(language_level_select.value).to eql(language_skills[i].level)
      end
      language_certificate_inputs.each_with_index do |language_certificate_input, i|
        expect(language_certificate_input.value).to eql(language_skills[i].certificate)
      end
    else
      default_languages = %w[DE EN FR]
      expect(language_selects.count).to eql(3)
      language_selects.each_with_index do |language_select, i|
        expect(language_select.value).to eql(default_languages[i])
      end
      language_level_selects.each do |language_level_select|
        expect(language_level_select.value).to eql('Keine')
      end
      language_certificate_inputs.each do |language_certificate_input|
        expect(language_certificate_input.value).to eql('')
      end
    end
  end

  def add_language(language)
    #Create new language.
    page.all(".add_fields").last.click
    #Select language from dropdown in newly created language.
    select language, from: page.all('.language-select').last[:id]
  end

  describe 'Edit person', type: :feature, js: true do
    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'should have all edit fields' do
      bob = people(:bob)
      visit person_path(bob)
      click_link('Bearbeiten', href: edit_person_path(bob))
      check_edit_fields(bob, true)
    end

    it 'should edit and save changes' do
      bob = people(:bob)
      old_number_of_roles = bob.person_roles.count
      visit person_path(bob)
      click_link('Bearbeiten', href: edit_person_path(bob))
      fill_out_person_form
      save_button = find_button("Person aktualisieren")
      scroll_to(save_button, align: :center)
      save_button.click
      assert_form_persisted(old_number_of_roles)
    end

    it 'should edit and cancel without saving' do
      person = Person.first
      visit person_path(person)
      click_link('Bearbeiten', href: edit_person_path(person))
      fill_out_person_form
      click_link 'Abbrechen'
      expect(person.attributes).to eql(Person.first.attributes)
    end

    it 'should have edit fields disabled if ptime sync is active' do
      enable_ptime_sync
      bob = people(:bob)
      visit person_path(bob)
      click_link('Bearbeiten', href: edit_person_path(bob))
      page.find('#person_name').disabled?
      page.find('#person_email').disabled?
      page.find('#person_title').disabled?
      page.find('#person_person_roles_attributes_0_role_id').disabled?
      page.find('#person_person_roles_attributes_0_person_role_level_id').disabled?
      page.find('#person_person_roles_attributes_0_percent').disabled?
      page.find('#person_department_id').disabled?
      page.find('#person_company_id').disabled?
      page.find('#person_location').disabled?
      page.find('#person_birthdate').disabled?
      page.find('#nat-two-checkbox').disabled?
      page.find('#person_nationality').disabled?
      page.find('#person_marital_status').disabled?
      page.find('#person_shortname').disabled?
    end

    it('should correctly disable languages if they are selected, changed, created or deleted') {
      bob = people(:bob)
      visit person_path(bob)
      click_link('Bearbeiten', href: edit_person_path(bob))

      add_language('JA')
      add_language('ZH')

      lang_selects = page.all('.language-select')
      #ZH
      lang_select = lang_selects[-1]
      #JA
      lang_select2 = lang_selects[-2]

      #Check if currently selected language is still enabled
      expect(lang_select.find('option', text: 'ZH')).not_to be_disabled
      #Check if some other language is enabled
      expect(lang_select.find('option', text: 'UR')).not_to be_disabled
      #Check if language selected in another dropdown is disabled
      expect(lang_select.find('option', text: 'JA')).to be_disabled

      expect(lang_select2.find('option', text: 'JA')).not_to be_disabled
      expect(lang_select.find('option', text: 'UR')).not_to be_disabled
      expect(lang_select2.find('option', text: 'ZH')).to be_disabled

      #Change language selected in dropdown
      select 'KO', from: lang_select[:id]
      #Old language selected in dropdown should not be disabled anymore
      expect(lang_select2.find('option', text: 'ZH')).not_to be_disabled
      #New language selected should be disabled
      expect(lang_select2.find('option', text: 'KO')).to be_disabled

      #Delete language
      page.all('.remove_fields')[-1].click
      #Language should now be re-enabled
      expect(lang_select2.find('option', text: 'KO')).not_to be_disabled
    }

    it('should display error when uploading a too big avatar file') do
      bob = people(:bob)
      visit person_path(bob)
      click_link('Bearbeiten', href: edit_person_path(bob))

      allow_any_instance_of(CarrierWave::SanitizedFile).to receive(:size).and_return(12.megabytes)

      page.attach_file("avatar-uploader", Rails.root + 'app/assets/images/favicon.png')
      page.find("#save-button").click
      expect(page).to have_css('.alert-danger', text: 'Bild darf nicht grösser als 10MB sein')
    end
  end

  describe 'Create person', type: :feature, js: true do
    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'should have all edit fields' do
      visit people_path
      new_person = Person.new
      click_link 'Neues Profil'
      check_edit_fields(new_person, false)
    end

    it 'should create new person' do
      visit people_path
      click_link 'Neues Profil'
      fill_out_person_form
      click_button "Person erstellen"

      assert_form_persisted(0)
    end

    it 'should go back to overview after cancelling and not save new person' do
      visit people_path
      click_link 'Neues Profil'
      fill_out_person_form
      click_link 'Abbrechen'
      expect(page).to have_current_path(people_path)
      expect(Person.all.find_by(name: "Hansjakobli")).to be_nil
    end
  end

  describe 'Visit person', type: :feature, js: true do
    let(:longmax) { people(:longmax) }

    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'should display message when no skills are rated' do
      visit person_path(longmax)
      expect(page).to have_selector('p.alert.alert-info.d-flex.justify-content-between', text: t("people.cv.no_skills_rated_msg"))
    end

    it 'should delete person' do
      visit person_path(longmax)
      click_button(t("people.global.more_actions"))
      accept_confirm do
        click_link(t("people.global.link.delete"), href: person_path(longmax))
      end
      expect(page).to have_selector('.alert', text: I18n.t("crud.destroy.flash.success", model: longmax))
    end

    it 'should not show delete button when ptime sync is active' do
      enable_ptime_sync
      visit person_path(longmax)
      click_button(t("people.global.more_actions"))
      expect(page).not_to have_button(t("people.global.link.delete"))
    end
  end

  describe 'Click Quick loading Buttons' do
    it 'shows profile after clicking button' do
      sign_in auth_users(:admin), scope: :auth_user
      visit people_path
      expect(page).to have_content(t("people.index.profile"))
      click_link(t("people.index.profile"))
      expect(page).to have_content(t("people.profile.personals"))
    end

    it 'shows export cv dialog after clicking button' do
      sign_in auth_users(:admin), scope: :auth_user
      visit people_path
      expect(page).to have_content(t("people.index.export_cv"))
      click_link(t("people.index.export_cv"))
      allow_any_instance_of(Odt::PuzzleCv).to receive(:export).and_call_original
    end

    it 'does not shows buttons if the logged-in user has no profile' do
      sign_in auth_users(:user), scope: :auth_user
      visit people_path
      expect(page).to have_no_content(t("people.index.export_cv"))
      expect(page).to have_no_content(t("people.index.profile"))
    end
  end
end
