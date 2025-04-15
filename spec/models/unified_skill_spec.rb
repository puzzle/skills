require 'rails_helper'

describe UnifiedSkill do
  it 'should correctly serialize attributes' do
    skill = Skill.first
    unified_skill = UnifiedSkill.create!(skill1_attrs: skill.attributes, skill2_attrs: skill.attributes, unified_skill_attrs: skill.attributes)

    expect(unified_skill.skill1_attrs.is_a? Hash).to eql(true)
    expect(unified_skill.skill2_attrs.is_a? Hash).to eql(true)
    expect(unified_skill.unified_skill_attrs.is_a? Hash).to eql(true)
  end
end