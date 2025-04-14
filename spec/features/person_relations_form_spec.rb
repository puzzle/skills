require 'rails_helper'

describe :person_relations_form, type: :feature, js: true do
  let(:person) { people(:bob) }

  before(:each) do
    sign_in auth_users(:admin)
    visit person_path(person)
  end
  describe 'Should only delete person_relation and not person' do
    %w[advanced_trainings activities educations projects].each do |entity_name|
      it "Should delete #{entity_name}" do
        entity = person.send(entity_name).first
        entity_class_name = entity.class.to_s.underscore
        open_edit_form(entity)
        within("turbo-frame##{entity_class_name}_#{entity.id}") do
          accept_confirm do
            find('a', text: 'Löschen').click
          end
        end
        expect(page).not_to have_selector("#{entity_class_name}_#{entity.id}")
        expect(Person.find(person.id)).to be_present
      end
    end
  end
end