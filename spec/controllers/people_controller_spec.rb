require 'rails_helper'

describe PeopleController do
  describe 'PeopleController' do
    before { auth(:ken) }
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
          .exactly(14).times
          .and_call_original

        expect_any_instance_of(ODFReport::Report)
          .to receive(:add_image)
          .exactly(1).times
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

      it 'returns fws bob development' do
        bob = people(:bob)

        expect_any_instance_of(Odt::Fws)
          .to receive(:export)
          .exactly(1).times
          .and_call_original

        process :export_fws, method: :get, format: 'odt', params: { discipline: 'development', person_id: bob.id }
        expect(@response['Content-Disposition']).to match(
          /attachment; filename=\"fachwissensskala-entwicklung-bob-anderson.odt\"/
        )
      end

      it 'returns fws bob sys' do
        bob = people(:bob)

        expect_any_instance_of(Odt::Fws)
          .to receive(:export)
          .exactly(1).times
          .and_call_original

        process :export_fws, method: :get, format: 'odt', params: { discipline: 'system_engineering', person_id: bob.id }
        expect(@response['Content-Disposition']).to match(
          /attachment; filename=\"fachwissensskala-sys-bob-anderson.odt\"/
        )
      end

      it 'returns empty development fws' do
        expect_any_instance_of(Odt::Fws)
          .to receive(:empty_export)
          .exactly(1).times
          .and_call_original

        process :export_empty_fws, method: :get, format: 'odt', params: { discipline: 'development'}
        expect(@response['Content-Disposition']).to match(
          /attachment; filename=\"fachwissensskala-entwicklung.odt\"/
        )
      end

      it 'returns empty system_enigneer fws' do
        expect_any_instance_of(Odt::Fws)
          .to receive(:empty_export)
          .exactly(1).times
          .and_call_original

        process :export_empty_fws, method: :get, format: 'odt', params: { discipline: 'system_engineering'}
        expect(@response['Content-Disposition']).to match(
          /attachment; filename=\"fachwissensskala-sys.odt\"/
        )
      end
    end

    describe 'GET index' do
      it 'returns all people without nested models without any filter' do
        expect(Person).not_to receive(:search)

        keys = %w(name)

        get :index

        people = json['data']

        expect(people.count).to eq(2)
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
        keys = %w[birthdate picture_path language location martial_status
                  updated_by name nationality nationality2 title competences]

        bob = people(:bob)

        process :show, method: :get, params: { id: bob.id }

        bob_attrs = json['data']['attributes']

        expect(bob_attrs.count).to eq(12)
        expect(bob_attrs['nationality']).to eq('CH')
        expect(bob_attrs['nationality2']).to eq('SE')
        json_object_includes_keys(bob_attrs, keys)
        # expect(bob_attrs['picture-path']).to eq("/api/people/#{bob.id}/picture")

        nested_keys = %w(advanced_trainings activities projects educations company roles)
        nested_attrs = json['data']['relationships']

        expect(nested_attrs.count).to eq(7)
        json_object_includes_keys(nested_attrs, nested_keys)
      end
    end

    describe 'POST create' do
      it 'creates new person' do

        company = companies(:partner)
        role1 = roles(:'software-engineer')
        role2 = roles(:'system-engineer')
        person = { birthdate: Time.current,
                   picture: fixture_file_upload('files/picture.png', 'image/png'),
                   language: 'German',
                   location: 'Bern',
                   martial_status: 'single',
                   name: 'test',
                   nationality: 'CH',
                   nationality2: 'FR',
                   title: 'Bsc in tester',
                   }
        relationships = {company: { data: { id: company.id, type: 'companies' }},
                         roles: { data: [{ id: role1.id, type: 'role'}, { id: role2.id, type: 'role'}]}}
        

        params = { data: {
          type: 'people',
          attributes: person, 
          relationships: relationships
        }
        }
        process :create, method: :post, params: params 

        new_person = Person.find_by(name: 'test')
        expect(new_person).not_to eq(nil)
        expect(new_person.location).to eq('Bern')
        expect(new_person.language).to eq('German')
        expect(new_person.nationality).to eq('CH')
        expect(new_person.nationality2).to eq('FR')
        [role1, role2].each do |role|
          expect(new_person.roles).to include(role)
        end
        expect(new_person.picture.url)
          .to include("#{Rails.root}/uploads/person/picture/#{new_person.id}/picture.png")
      end
    end

    describe 'PUT update' do
      it 'updates existing person' do
        bob = people(:bob)

        role = roles(:'system-engineer')
        process :update, method: :put, params: {
          id: bob.id, data: { attributes: { location: 'test_location' }, relationships: { roles: { data: [ { id: role.id, type: 'role' }]}} }
        }

        bob.reload
        expect(bob.location).to eq('test_location')
        expect(bob.roles).to eq([role])
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
      end
    end
  end

  describe 'authentication' do
    it 'renders unauthorized without headers' do
      process :index, method: :get
      expect(response.status).to eq(401)
    end

    it 'render unauthorized if user does not exists' do
      @request.headers['ldap-uid'] = 0o000
      @request.headers['api-token'] = 'test'
      process :index, method: :get

      expect(response.status).to eq(401)
    end

    it 'render unauthorized if api_token doesnt match' do
      @request.headers['ldap-uid'] = users(:ken).ldap_uid
      @request.headers['api-token'] = 'wrong token'
      process :index, method: :get

      expect(response.status).to eq(401)
    end

    it 'does nothing if api_token is correct' do
      ken = users(:ken)
      @request.headers['ldap-uid'] = ken.ldap_uid
      @request.headers['api-token'] = ken.api_token
      process :index, method: :get


      expect(response.status).to eq(200)
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
