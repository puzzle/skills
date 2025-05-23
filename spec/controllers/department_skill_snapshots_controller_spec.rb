require 'rails_helper'

describe DepartmentSkillSnapshotsController do

  before(:each) do
    sign_in auth_users(:admin), scope: :auth_user
  end

  it "Should return data JSON in correct format" do
    get :index, params: {
      department_id: 457905166,
      skill_id: "31989848",
      year: 2025
    }

    expect(response).to be_successful

    data = assigns(:data)
    json = JSON.parse(data)

    expect(json["labels"]).to eq(%w[Januar Februar März April Mai Juni Juli August September Oktober November Dezember])

    expect(json["datasets"].find { |ds| ds["label"] == "Azubi" }["data"].length).to eq(12)
    expect(json["datasets"].find { |ds| ds["label"] == "Junior" }["data"].length).to eq(12)
    expect(json["datasets"].find { |ds| ds["label"] == "Senior" }["data"].length).to eq(12)
    expect(json["datasets"].find { |ds| ds["label"] == "Professional" }["data"].length).to eq(12)
    expect(json["datasets"].find { |ds| ds["label"] == "Expert" }["data"].length).to eq(12)

    # Index 4 equals the month May here
    expect(json["datasets"].find { |ds| ds["label"] == "Junior" }["data"][4]).to eq(2)
    expect(json["datasets"].find { |ds| ds["label"] == "Expert" }["data"][4]).to eq(1)
  end

  it "Should only return data JSON with data from the correct company and year" do
    get :index, params: {
      department_id: 457905166,
      skill_id: "31989848",
      year: 2024
    }

    expect(response).to be_successful

    data = assigns(:data)
    json = JSON.parse(data)

    expect(json["datasets"].find { |ds| ds["label"] == "Azubi" }["data"][0]).to eq(2)
    expect(json["datasets"].find { |ds| ds["label"] == "Senior" }["data"][0]).to eq(1)

    expect(json["datasets"].find { |ds| ds["label"] == "Azubi" }["data"].drop(2).all?(&:zero?)).to eql(true)
    expect(json["datasets"].find { |ds| ds["label"] == "Junior" }["data"].all?(&:zero?)).to eql(true)
    expect(json["datasets"].find { |ds| ds["label"] == "Senior" }["data"].drop(1).all?(&:zero?)).to eql(true)
    expect(json["datasets"].find { |ds| ds["label"] == "Professional" }["data"].all?(&:zero?)).to eql(true)
    expect(json["datasets"].find { |ds| ds["label"] == "Expert" }["data"].all?(&:zero?)).to eql(true)
  end
end