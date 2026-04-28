require 'rails_helper'

describe SkillSearch::SearchFilter do
  def people_skill(skill_id:, level: 3, interest: 3)
    instance_double(PeopleSkill, skill_id: skill_id, level: level, interest: interest)
  end

  describe '#skill?' do
    it 'is true when a skill_id is set' do
      expect(described_class.new(42)).to be_skill
    end

    it 'is false when no skill_id is given' do
      expect(described_class.new).not_to be_skill
    end
  end

  describe '#or?' do
    it 'is true when operator is :or' do
      expect(described_class.new(42, 1, 1, :or)).to be_or
    end

    it 'is false when operator is :and' do
      expect(described_class.new(42, 1, 1, :and)).not_to be_or
    end

    it 'defaults to :and' do
      expect(described_class.new(42)).not_to be_or
    end

    it 'defaults to :and when operator is nil' do
      expect(described_class.new(42, 1, 1, nil)).not_to be_or
    end
  end

  describe '#match?' do
    let(:filter) { described_class.new(1, 2, 2) }

    it 'matches when skill_id, level and interest all meet the threshold' do
      expect(filter.match?(people_skill(skill_id: 1, level: 3, interest: 3))).to be true
    end

    it 'matches exactly at the threshold' do
      expect(filter.match?(people_skill(skill_id: 1, level: 2, interest: 2))).to be true
    end

    it 'does not match when skill_id differs' do
      expect(filter.match?(people_skill(skill_id: 99))).to be false
    end

    it 'does not match when level is below threshold' do
      expect(filter.match?(people_skill(skill_id: 1, level: 1))).to be false
    end

    it 'does not match when interest is below threshold' do
      expect(filter.match?(people_skill(skill_id: 1, interest: 1))).to be false
    end
  end

  describe '#match_any?' do
    let(:filter) { described_class.new(1, 2, 2) }

    it 'is true when at least one skill in the list matches' do
      skills = [people_skill(skill_id: 99), people_skill(skill_id: 1)]
      expect(filter.match_any?(skills)).to be true
    end

    it 'is false when no skill in the list matches' do
      expect(filter.match_any?([people_skill(skill_id: 99)])).to be false
    end
  end

  describe '.group_match?' do
    let(:skill_a) { people_skill(skill_id: 1) }
    let(:skill_b) { people_skill(skill_id: 2) }

    it 'is true when every filter in the group matches' do
      group = [described_class.new(1, 1, 1), described_class.new(2, 1, 1)]
      expect(described_class.group_match?(group, [skill_a, skill_b])).to be true
    end

    it 'is false when any filter in the group does not match' do
      group = [described_class.new(1, 1, 1), described_class.new(99, 1, 1)]
      expect(described_class.group_match?(group, [skill_a, skill_b])).to be false
    end
  end
end
