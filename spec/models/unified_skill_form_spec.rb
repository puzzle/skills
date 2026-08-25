require 'rails_helper'

describe UnifiedSkillForm do
  context 'validations' do
    it 'should correctly validate empty instance' do
      unified_skill_form = UnifiedSkillForm.new
      unified_skill_form.valid?

      expect(unified_skill_form.checked_conflicts).to eql(false)
      expect(unified_skill_form.errors[:old_skill_id1].first).to eql('muss ausgefüllt werden')
      expect(unified_skill_form.errors[:old_skill_id2].first).to eql('muss ausgefüllt werden')
      expect(unified_skill_form.errors[:new_skill].first).to eql('muss ausgefüllt werden')
      expect(unified_skill_form.errors[:category].first).to eql('muss ausgefüllt werden')
      expect(unified_skill_form.errors[:title].first).to eql('muss ausgefüllt werden')
    end

    it 'should correctly validate instance with skill' do
      skill = Skill.first
      unified_skill_form = UnifiedSkillForm.new(new_skill: skill.attributes)
      unified_skill_form.valid?

      expect(unified_skill_form.errors[:old_skill_id1].first).to eql('muss ausgefüllt werden')
      expect(unified_skill_form.errors[:old_skill_id2].first).to eql('muss ausgefüllt werden')
      expect(unified_skill_form.errors[:new_skill]).to be_empty
      expect(unified_skill_form.errors[:category]).to be_empty
      expect(unified_skill_form.errors[:title].first).to eql('ist bereits vergeben')

      skill.title = 'Unified skill'
      unified_skill_form.new_skill = skill.attributes
      unified_skill_form.valid?
      expect(unified_skill_form.errors[:title]).to be_empty
    end

    it 'should correctly validate that skill ids are not equal' do
      unified_skill_form = UnifiedSkillForm.new(old_skill_id1: 1, old_skill_id2: 1)
      unified_skill_form.valid?

      expect(unified_skill_form.errors[:old_skill_id1].first).to eql('und Skill 2 dürfen nicht identisch sein')
    end

    it 'allows the unified skill to reuse a selected skill title and category' do
      skill1 = skills(:rails)
      skill2 = skills(:bash)
      unified_skill_form = UnifiedSkillForm.new(
        old_skill_id1: skill1.id,
        old_skill_id2: skill2.id,
        new_skill: {
          title: skill1.title,
          category_id: skill1.category_id,
          radar: skill1.radar,
          portfolio: skill1.portfolio,
          default_set: skill1.default_set
        }
      )

      expect(unified_skill_form).to be_valid
    end

    it 'rejects a title and category used by an unselected skill' do
      skill1 = skills(:rails)
      skill2 = skills(:bash)
      existing_skill = skills(:junit)
      unified_skill_form = UnifiedSkillForm.new(
        old_skill_id1: skill1.id,
        old_skill_id2: skill2.id,
        new_skill: {
          title: existing_skill.title,
          category_id: existing_skill.category_id,
          radar: existing_skill.radar,
          portfolio: existing_skill.portfolio,
          default_set: existing_skill.default_set
        }
      )

      expect(unified_skill_form).not_to be_valid
      expect(unified_skill_form.errors[:title].first).to eql('ist bereits vergeben')
    end
  end
end
