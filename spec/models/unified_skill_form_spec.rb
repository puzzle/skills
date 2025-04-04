require 'rails_helper'

describe UnifiedSkillForm do
  context 'validations' do
    it 'should correctly validate empty instance' do
      unified_skill_form = UnifiedSkillForm.new
      unified_skill_form.valid?

      expect(unified_skill_form.errors[:old_skill_id1].first).to eql('muss ausgefüllt werden')
      expect(unified_skill_form.errors[:old_skill_id2].first).to eql('muss ausgefüllt werden')
      expect(unified_skill_form.errors[:new_skill].first).to eql('muss ausgefüllt werden')
      expect(unified_skill_form.errors[:skill_category].first).to eql('muss ausgefüllt werden')
      expect(unified_skill_form.errors[:skill_title].first).to eql('muss ausgefüllt werden')
    end

    it 'should correctly validate instance with skill' do
      skill = Skill.first
      unified_skill_form = UnifiedSkillForm.new(new_skill: skill.attributes)
      unified_skill_form.valid?

      expect(unified_skill_form.errors[:old_skill_id1].first).to eql('muss ausgefüllt werden')
      expect(unified_skill_form.errors[:old_skill_id2].first).to eql('muss ausgefüllt werden')
      expect(unified_skill_form.errors[:new_skill]).to be_empty
      expect(unified_skill_form.errors[:skill_category]).to be_empty
      expect(unified_skill_form.errors[:skill_title].first).to eql('ist bereits vergeben')

      skill.title = 'Unified skill'
      unified_skill_form.new_skill = skill.attributes
      unified_skill_form.valid?
      expect(unified_skill_form.errors[:skill_title]).to be_empty
    end

    it 'should correctly validate that skill ids are not equal' do
      unified_skill_form = UnifiedSkillForm.new(old_skill_id1: 1, old_skill_id2: 1)
      unified_skill_form.valid?

      expect(unified_skill_form.errors[:old_skill_id1].first).to eql('darf nicht gleich Skill 2 sein')
    end
  end
end