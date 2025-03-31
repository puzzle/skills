require 'rails_helper'

describe UnifiedSkillsController do
  before(:each) do
    sign_in(auth_users(:admin))
  end

  it 'should unify two skills' do
    skill1 = Skill.first
    skill2 = Skill.second
    old_people_skills_count = PeopleSkill.where(skill_id: [skill1.id, skill2.id]).size

    new_skill = {title: 'A unified skill', radar: 'adopt', portfolio: 'aktiv', category_id: Category.first.id}

    post :create, params: {old_skill_id1: skill1.id, old_skill_id2: skill2.id, skill: new_skill}

    expect(UnifiedSkill.find_by(skill1_attrs: skill1.attributes, skill2_attrs: skill2.attributes)).not_to be_nil

    expect(Skill.find_by(id: skill1.id)).to be_nil
    expect(Skill.find_by(id: skill2.id)).to be_nil
    expect(PeopleSkill.where(skill_id: [skill1.id, skill2.id])).to be_empty

    merged_skill = Skill.find_by!(title: 'A unified skill')
    expect(PeopleSkill.where(skill_id: merged_skill.id).size).to eql(old_people_skills_count)
  end
end