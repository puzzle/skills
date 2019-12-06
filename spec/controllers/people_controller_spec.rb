require 'rails_helper'

describe PeopleController do
  describe 'PeopleController' do
    before { load_pictures }

    describe 'Export person as odt' do
      it 'returns bob' do
        bob = people(:bob)

        expect_any_instance_of(Odt::Cv)
          .to receive(:export)
          .exactly(1).times
          .and_call_original

        expect_any_instance_of(ODFReport::Report)
          .to receive(:add_field)
          .exactly(13).times
          .and_call_original

        expect_any_instance_of(ODFReport::Report)
          .to receive(:add_image)
          .exactly(1).times
          .and_call_original

        expect_any_instance_of(ODFReport::Report)
          .to receive(:add_table)
          .exactly(6).times
          .and_call_original

        process :show, method: :get, format: 'odt', params: { id: bob.id }
      end

      it 'check filename' do
        process :show, method: :get, format: 'odt', params: { id: people(:bob).id }
        expect(@response['Content-Disposition']).to match(
          /filename="bob_anderson_cv.odt"/
        )
      end
    end

    describe 'GET index' do
      it 'returns all people without nested models without any filter' do
        expect(Person).not_to receive(:search)

        keys = %w(name)

        get :index

        people = json['data']

        expect(people.count).to eq(3)
        alice_attrs = people.first['attributes']
        expect(alice_attrs.count).to eq(1)
        expect(alice_attrs.first[1]).to eq('Alice Mante')
        json_object_includes_keys(alice_attrs, keys)
        expect(people).not_to include('relationships')
      end

      it 'filters persons for term if given' do
        expect(Person)
          .to receive(:search)
          .with('London')
          .exactly(1).times
          .and_call_original

        get :index, params: { q: 'London' }
      end
    end

    describe 'GET show' do
      it 'returns person with nested modules' do
        keys = %w[birthdate picture_path location marital_status
                  updated_by name nationality nationality2 title competence_notes]

        bob = people(:bob)

        process :show, method: :get, params: { id: bob.id }

        bob_attrs = json['data']['attributes']

        expect(bob_attrs.count).to eq(12)
        expect(bob_attrs['nationality']).to eq('CH')
        expect(bob_attrs['nationality2']).to eq('SE')
        json_object_includes_keys(bob_attrs, keys)
        expect(bob_attrs['picture_path']).to match("/api/people/#{bob.id}/picture\?")

        nested_keys = %w(advanced_trainings activities projects educations company roles language_skills person_roles)
        nested_attrs = json['data']['relationships']

        expect(nested_attrs.count).to eq(9)
        json_object_includes_keys(nested_attrs, nested_keys)
      end
    end

    describe 'POST create' do
      it 'creates new person' do
        company = companies(:partner)
        department = departments(:sys)

        person = { birthdate: Time.current,
                   location: 'Bern',
                   marital_status: 'single',
                   name: 'test',
                   nationality: 'CH',
                   nationality2: 'FR',
                   title: 'Bsc in tester',
                   email: 'test@example.com',
                   }

        relationships = {
          company: { data: { id: company.id, type: 'companies' }},
          department: {data: {id: department.id, name: department.name}}
        }

        params = {
          data: {
            type: 'people',
            attributes: person,
            relationships: relationships
          }
        }

        process :create, method: :post, params: params

        new_person = Person.find_by(name: 'test')
        expect(new_person).not_to eq(nil)
        expect(new_person.location).to eq('Bern')
        expect(new_person.nationality).to eq('CH')
        expect(new_person.nationality2).to eq('FR')
      end
    end

    describe 'PUT update' do
      it 'updates existing person' do
        bob = people(:bob)
        company = companies(:partner)

        process :update, method: :put, params: {
          id: bob.id, data: { attributes: { location: 'test_location' },
                              relationships: { company: { data: { id: company.id, type: 'company' }}}
                            }
        }

        bob.reload
        expect(bob.location).to eq('test_location')
        expect(bob.company).to eq(company)
      end
    end

    describe 'DELETE destroy' do
      it 'destroys existing person' do
        bob = people(:bob)
        process :destroy, method: :delete, params: { id: bob.id }

        expect(Person.exists?(bob.id)).to eq(false)
        expect(Activity.exists?(person_id: bob.id)).to eq(false)
        expect(AdvancedTraining.exists?(person_id: bob.id)).to eq(false)
        expect(Project.exists?(person_id: bob.id)).to eq(false)
        expect(Education.exists?(person_id: bob.id)).to eq(false)
        expect(LanguageSkill.exists?(person_id: bob.id)).to eq(false)
        expect(PersonRole.exists?(person_id: bob.id)).to eq(false)
      end
    end
  end

  private

  def update_params(object_id, updated_attributes, _user_id, model_type)
    { data: { id: object_id,
              attributes: updated_attributes,
              type: model_type },
      id: object_id }
  end
end
