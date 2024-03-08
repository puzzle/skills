require 'rails_helper'

describe PeopleController do
  describe 'Update Person' do
    render_views
    it 'should save nationality2 as nil if checkbox is unchecked and save it if it is checked' do
      person = people(:bob)
      patch :update, params: {id: person.id, person: person.attributes, has_nationality2: {checked: "1"}}
      expect(JSON.parse(response.body)['nationality2']).to eql(person.nationality2)
    end
  end
end