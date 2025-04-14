require 'rails_helper'

describe Admin::UnifiedSkillsController do
  before(:each) do
    sign_in(auth_users(:admin))
  end

  let(:new_skill) { { title: 'A unified skill', radar: 'adopt', portfolio: 'aktiv', category_id: Category.first.id, default_set: true } }

  def check_merged_people_skill_values(merged_people_skill, original_people_skill)
    expect(merged_people_skill.level).to eql(original_people_skill.level)
    expect(merged_people_skill.interest).to eql(original_people_skill.interest)
    expect(merged_people_skill.certificate).to eql(original_people_skill.certificate)
    expect(merged_people_skill.core_competence).to eql(original_people_skill.core_competence)
  end

  it 'should unify two skills' do
    skill1 = skills(:bash)
    skill2 = skills(:webcomponents)

    old_people_skills_count = PeopleSkill.where(skill_id: [skill1.id, skill2.id]).size

    post :create, params: { unified_skill_form: { old_skill_id1: skill1.id, old_skill_id2: skill2.id, checked_conflicts: true, new_skill: new_skill } }

    unified_skill = UnifiedSkill.find_by(skill1_attrs: skill1.attributes, skill2_attrs: skill2.attributes)
    expect(unified_skill.unified_skill_attrs.excluding('id', 'updated_at', 'created_at')).to eql(new_skill.stringify_keys)

    expect(Skill.find_by(id: skill1.id)).to be_nil
    expect(Skill.find_by(id: skill2.id)).to be_nil
    expect(PeopleSkill.where(skill_id: [skill1.id, skill2.id])).to be_empty

    merged_skill = Skill.find_by!(title: 'A unified skill')
    expect(PeopleSkill.where(skill_id: merged_skill.id).size).to eql(old_people_skills_count)
  end

  it 'should choose better rating when unifying skills that are both rated by a single person' do
    skill1 = skills(:rails)
    skill2 = skills(:bash)
    wally = people(:wally)
    wally_rails = people_skills(:wally_rails)
    wally_bash = people_skills(:wally_bash)

    expect(wally_bash.level).to be > wally_rails.level

    post :create, params: { unified_skill_form: { old_skill_id1: skill1.id, old_skill_id2: skill2.id, checked_conflicts: true, new_skill: new_skill } }

    expect(PeopleSkill.find_by(id: wally_rails.id)).to be_nil

    merged_people_skill = Skill.find_by!(title: 'A unified skill').people_skills.find_by!(person_id: wally.id)
    check_merged_people_skill_values(merged_people_skill, wally_bash)
  end

  it 'should choose a people skill even if rating is the same for both skills' do
    skill1 = skills(:junit)
    skill2 = skills(:bash)
    wally = people(:wally)
    wally_junit = people_skills(:wally_junit)
    wally_bash = people_skills(:wally_bash)

    expect(wally_junit.level).to eql(wally_bash.level)

    post :create, params: { unified_skill_form: { old_skill_id1: skill1.id, old_skill_id2: skill2.id, checked_conflicts: true, new_skill: new_skill } }

    expect(PeopleSkill.find_by(id: wally_bash.id)).to be_nil

    merged_people_skill = Skill.find_by!(title: 'A unified skill').people_skills.find_by!(person_id: wally.id)
    check_merged_people_skill_values(merged_people_skill, wally_junit)
  end
end