require 'rails_helper'

describe PeopleController do
  describe 'PeoplController' do
    before { auth(:ken) }

    describe 'Export person as odt' do
      it 'returns bob' do
        bob = people(:bob)

        expect_any_instance_of(Person)
          .to receive(:export)
          .exactly(1).times
          .and_call_original

        expect_any_instance_of(ODFReport::Report)
          .to receive(:add_field)
          .exactly(14).times
          .and_call_original

        expect_any_instance_of(ODFReport::Report)
          .to receive(:add_table)
          .exactly(4).times
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
      it 'returns all people without nested models' do
        keys = %w(id birthdate profile_picture language location martial_status
                  updated_by name origin role title status)

        get :index

        people = json['people']

        expect(people.count).to eq(2)
        expect(people.first.count).to eq(12)
        json_object_includes_keys(people.first, keys)
      end

      describe 'GET show' do
        it 'returns person with nested modules' do
          keys = %w(id birthdate profile_picture language location martial_status updated_by name origin
                    role title status advanced_trainings activities projects educations competences)

          bob = people(:bob)

          process :show, method: :get, params: { id: bob.id }

          bob_json = json['person']

          expect(bob_json.count).to eq(17)
          json_object_includes_keys(bob_json, keys)
        end

        describe 'POST create' do
          it 'creates new person' do
            person = { birthdate: Time.now,
                       profile_picture: 'test',
                       language: 'German',
                       location: 'Bern',
                       martial_status: 'single',
                       name: 'test',
                       origin: 'Switzerland',
                       role: 'tester',
                       title: 'Bsc in tester',
                       status_id: 2 }

            process :create, method: :post, params: { person: person }

            new_person = Person.find_by(name: 'test')
            expect(new_person).not_to eq(nil)
            expect(new_person.location).to eq('Bern')
            expect(new_person.language).to eq('German')
          end
        end

        describe 'PUT update' do
          it 'updates existing person' do
            bob = people(:bob)

            process :update, method: :put, params: { id: bob.id, person: { location: 'test_location' } }

            bob.reload
            expect(bob.location).to eq('test_location')
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
            expect(Competence.exists?(person_id: bob.id)).to eq(false)
          end
        end
      end

      describe 'application controller before filter' do
        it 'renders unauthorized if no params' do
          process :index, method: :get, params: {}
          expect(response.status).to eq(401)
        end

        it 'render unauthorized if user does not exists' do
          process :index, method: :get, params: { ldap_uid: 0o000, api_token: 'test' }

          expect(response.status).to eq(401)
        end

        it 'render unauthorized if api_token doesnt match' do
          process :index, method: :get, params: { ldap_uid: users(:ken).ldap_uid,
                                                  api_token: 'wrong token' }

          expect(response.status).to eq(401)
        end

        it 'does nothing if api_token is correct' do
          ken = users(:ken)
          process :index, method: :get, params: { ldap_uid: ken.ldap_uid,
                                                  api_token: ken.api_token }

          expect(response.status).to eq(200)
        end
      end
    end
  end
end
