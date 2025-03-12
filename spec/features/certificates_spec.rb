require 'rails_helper'

describe :certificates, type: :feature, js: true do
  before(:each) do
    admin = auth_users(:admin)
    login_as(admin, scope: :auth_user)
    visit certificates_path
  end

  describe 'Create certificate' do
    before(:each) do
      click_link(href: new_certificate_path)
    end

    it 'creates new certificate' do
      new_certificate_values = {
        name: 'New certificate name', description: 'New certificate description', points_value: 12345,
        provider: 'New certificate provider', exam_duration: 30, type_of_exam: 'New exam type',
        study_time: 28, notes: 'New certificate notes'
      }

      new_certificate_values.each do |attr, value|
        fill_in "certificate_#{attr}", with: value
      end

      click_button 'Zertifikat erstellen'

      new_certificate_values.each do |_, value|
        expect(page).to have_text(value)
      end
    end

    it 'displays error messages when present' do
      click_button 'Zertifikat erstellen'
      expect(page).to have_css('.alert.alert-danger')

      empty_cert = Certificate.new
      empty_cert.valid?
      empty_cert.errors.each do |error|
        expect(page).to have_text(error.full_message)
      end
    end

    it 'redirects to the certificate index when the cancel button is clicked' do
      expect(page).to have_text("Zertifikat erstellen")
      click_link("Cancel")
      expect(page).not_to have_text("Zertifikat erstellen")
    end
  end

  describe 'edit certificate' do
    updated_certificate_values = {
      name: 'Updated name', description: 'Updated description', points_value: 1000,
      provider: 'Updated provider', exam_duration: 5, type_of_exam: 'Updated exam type',
      study_time: 10, notes: 'Updated notes'
    }

    def edit_certificate(certificate_id, updated_certificate_values, should_save)
      within "#certificate_#{certificate_id}" do
        page.find('.icon.icon-pencil').click
        updated_certificate_values.each do |attr, value|
          fill_in "certificate_#{attr}", with: value
        end
        should_save ? save_certificate : cancel_certificate
      end
    end

    def save_certificate
      save_button = page.find("input[type='image']")
      save_button.click
      expect(page).to have_no_css("input#certificate_name").or have_css('.alert.alert-danger')
    end

    def cancel_certificate
      cancel_button = page.first("a.action")
      cancel_button.click
    end

    it 'can edit certificate' do
      edit_certificate(Certificate.third.id, updated_certificate_values, true)

      updated_certificate = Certificate.third
      updated_certificate_values.each do |attr, value|
        expect(updated_certificate[attr]).to eql(value)
      end
    end

    it 'can cancel edit of certificate' do
      unedited_certificate = Certificate.first.freeze
      edit_certificate(Certificate.first.id, updated_certificate_values, false)
      expect(unedited_certificate.attributes).to eql(Certificate.first.attributes)
    end

    it 'displays validation errors when updating certificate' do
      empty_certificate_values = {
        name: '', description: '', points_value: '',
        provider: '', exam_duration: '', type_of_exam: '',
        study_time: '', notes: ''
      }
      edit_certificate(Certificate.second.id, empty_certificate_values, true)

      empty_cert = Certificate.new
      empty_cert.valid?
      empty_cert.errors.each do |error|
        expect(page).to have_text(error.full_message)
      end
    end
  end
end