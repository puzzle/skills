require "rails_helper"

RSpec.describe EmployeeQuantitiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/employee_quantities").to route_to("employee_quantities#index")
    end


    it "routes to #show" do
      expect(:get => "/employee_quantities/1").to route_to("employee_quantities#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/employee_quantities").to route_to("employee_quantities#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/employee_quantities/1").to route_to("employee_quantities#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/employee_quantities/1").to route_to("employee_quantities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/employee_quantities/1").to route_to("employee_quantities#destroy", :id => "1")
    end

  end
end
