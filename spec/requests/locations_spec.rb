require 'rails_helper'

RSpec.describe "Locations", type: :request do
  describe "GET /locations" do
    it "works! (now write some real specs)" do
      get locations_path
      expect(response).to have_http_status(200)
    end
  end
end
