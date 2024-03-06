require 'rails_helper'

describe SkillsController do
  describe 'Update Skill' do
    render_views

    it 'should switch category' do
      edited_skill = {**Skill.first.as_json.symbolize_keys,
                      category_parent: Category.where(title: "System-Engineering")[0].id}
      patch :update, params: {id: edited_skill[:id], skill: edited_skill, validate_only: true}
      expect(response.body).to have_select("skill_category_id", with_options: [Category.where(title: "System-Engineering")[0].children[0].title])
    end
  end
end
