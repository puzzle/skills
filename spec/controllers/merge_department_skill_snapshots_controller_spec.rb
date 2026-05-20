# frozen_string_literal: true

require "rails_helper"

describe Admin::MergeDepartmentSkillSnapshotsController do
  before(:each) do
    sign_in(auth_users(:admin))
  end

  describe "POST #create" do
    let(:dev_one) { departments(:"dev-one") }
    let(:dev_two) { departments(:"dev-two") }
    let(:sys)     { departments(:sys) }

    def valid_params(old:, new:)
      {
        merge_department_skill_form: {
          old_department_ids: old.map(&:id),
          new_department_id: new.id
        }
      }
    end

    it "merges department skill snapshots successfully" do
      expect_any_instance_of(DepartmentSkillsSnapshotBuilder)
        .to receive(:merge_department_skills_to_new_department)
              .with(
                old_department_ids: [dev_one.id, dev_two.id],
                new_department_id: sys.id
              )

      post :create, params: valid_params(old: [dev_one, dev_two], new: sys)

      expect(response).to redirect_to(new_admin_merge_department_skill_snapshot_path)

      expect(flash[:notice]).to be_present
      expect(flash[:alert]).to be_nil
    end

    it "does not merge and shows error when form is invalid (missing old departments)" do
      post :create, params: {
        merge_department_skill_form: {
          old_department_ids: [],
          new_department_id: sys.id
        }
      }

      expect(response).to redirect_to(new_admin_merge_department_skill_snapshot_path)
      expect(flash[:alert]).to be_present
    end

    it "does not merge and shows error when new department is missing" do
      post :create, params: {
        merge_department_skill_form: {
          old_department_ids: [dev_one.id],
          new_department_id: nil
        }
      }

      expect(response).to redirect_to(new_admin_merge_department_skill_snapshot_path)
      expect(flash[:alert]).to be_present
    end

    it "does not merge when same department is selected" do
      post :create, params: {
        merge_department_skill_form: {
          old_department_ids: [dev_one.id],
          new_department_id: dev_one.id
        }
      }

      expect(response).to redirect_to(new_admin_merge_department_skill_snapshot_path)
      expect(flash[:alert]).to include("kann nicht mit sich selbst zusammengeführt werden.")
    end
  end

  describe "GET #new" do
    it "assigns departments and form" do
      get :new

      expect(assigns(:departments)).to be_present
      expect(assigns(:merge_department_snapshots_form)).to be_a(MergeDepartmentSkillForm)
      expect(response).to be_successful
    end
  end
end