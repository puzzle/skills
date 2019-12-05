require 'rails_helper'

describe DepartmentsController do
  describe 'GET index' do
    it 'returns all departments' do
      get :index

      departments = json['data']

      expect(departments.count).to eq(5)
      expect(departments.first['attributes']['name']).to eq('/dev/one')
      expect(departments.second['attributes']['name']).to eq('/dev/two')
    end
  end

  describe 'GET show' do
    it 'returns sys department' do
       get :show, params:{ id: sys.id }

      department = json['data']['attributes']

      expect(department['name']).to eq('/sys')
    end
  end

  describe 'POST create department' do
    it 'creates department' do
       department = {data:{type:"departments",attributes:{name:"/dev/test"}}}

       process :create, method: :post, params: department

       newDepartment = Department.find_by(name: '/dev/test')
       expect(newDepartment.name).to eq('/dev/test')
    end
  end

  private

  def sys
    @sys ||= departments(:sys)
  end
end
