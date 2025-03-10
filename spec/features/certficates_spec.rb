require 'rails_helper'

describe :certificates do
  before(:each) do
    admin = auth_users(:admin)
    login_as(admin, scope: :auth_user)
  end

  describe 'Edit certificate', type: :feature, js: true do
    it 'can edit certificate in table' do
      visit certificates_path

      updated_certificate_values = {
        name: 'Updated name', description: 'Updated description', points_value: 1000,
        provider: 'Updated provider', exam_duration: 5, type_of_exam: 'Updated exam type',
        study_time: 10, notes: 'Updated notes'
      }

      within "#certificate_#{Certificate.third.id}" do
        page.find('.icon.icon-pencil').click
        updated_certificate_values.each do |attr, value|
          fill_in "certificate_#{attr}", with: value
        end
        save_button = page.find("input[type='image']")
        save_button.click
      end

      updated_certificate = Certificate.third
      updated_certificate_values.each do |attr, value|
        expect(updated_certificate[attr]).to eql(value)
      end
    end
  end
end