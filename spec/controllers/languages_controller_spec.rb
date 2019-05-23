require 'rails_helper'

describe LanguagesController do
  describe 'list' do
    it 'returns all languages' do
      process :index, method: :get

      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(71)
      expect(json["data"].first["attributes"]["iso1"]).to eq("AF")
    end
  end
end
