require 'rails_helper'

describe SkillsController do
  describe 'SkillsController as user' do

    before(:each) do
      load_pictures
      sign_in(auth_users(:admin))
    end
    render_views


    let(:edited_skill) { {"id" => skills(:rails).id, "category_parent" => categories('system-engineering').id,
                          "title" => "UpdatedSkill", "radar" => "adopt", "portfolio" => "passiv", "default_set" => false,
                          "category_id" => categories(:ruby).id} }
    let(:bob) { people(:bob) }


    it 'index returns all skills ' do
      get :index
      skills = assigns(:skills)
      expect(skills.sort).to eq skills().sort
      expect(response).to render_template("index")
    end

    it 'should switch category' do
      patch :update, params: {id: edited_skill["id"], skill: edited_skill, validate_only: true}
      expect(response.body).to have_select("skill_category_id", with_options: ['Linux-Engineering'])
    end

    it 'post returns all skills ' do
      title = 'new skill'
      category_id = categories(:java).id
      radar = "hold"
      portfolio = "passiv"

      post :create , params: { skill: { title: title, category_id: category_id, radar: radar, portfolio: portfolio} }
      skill = assigns(:skill)
      expect(skill.title).to eq title
      expect(skill.category_id).to eq category_id
      expect(skill.radar).to eq radar
      expect(skill.portfolio).to eq portfolio
      expect(response).to redirect_to(skills_path)
    end
  end
end
