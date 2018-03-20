require 'rails_helper'

RSpec.describe "EmployeeQuantities", type: :request do
  describe "GET /employee_quantities" do
    it "works! (now write some real specs)" do
      get employee_quantities_path
      expect(response).to have_http_status(200)
    end
  end
end
