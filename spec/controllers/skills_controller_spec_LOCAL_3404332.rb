require 'rails_helper'

describe SkillsController do
  describe 'Update Skill' do
    before(:each) do
      sign_in(auth_users(:admin))
    end
    render_views

    let(:edited_skill) { {"id" => skills(:rails).id, "category_parent" => categories('system-engineering').id,
                          "title" => "UpdatedSkill", "radar" => "adopt", "portfolio" => "passiv", "default_set" => false,
                          "category_id" => categories(:ruby).id} }

    it 'should switch category' do
      patch :update, params: {id: edited_skill["id"], skill: edited_skill, validate_only: true}
      expect(response.body).to have_select("skill_category_id", with_options: ['Linux-Engineering'])
    end
  end
end
