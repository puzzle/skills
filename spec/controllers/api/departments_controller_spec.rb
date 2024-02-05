require 'rails_helper'

describe Api::DepartmentsController do
  describe 'GET index' do
    it 'returns all departments' do
      get :index

      departments = json['data']

      expect(departments.count).to eq(5)
      expect(departments.first['attributes']['name']).to eq('/dev/one')
      expect(departments.second['attributes']['name']).to eq('/dev/two')
    end
  end

  private

  def sys
    @sys ||= departments(:sys)
  end
end
