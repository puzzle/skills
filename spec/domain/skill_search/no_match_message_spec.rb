require 'rails_helper'

describe SkillSearch::NoMatchMessage do
  let(:rails_filter) { SkillSearch::SearchFilter.new(skills(:rails).id, 3, 4) }
  let(:bash_filter)  { SkillSearch::SearchFilter.new(skills(:bash).id, 5, 2) }

  describe '#prefix' do
    it 'returns the no_match translation without department' do
      expect(described_class.new([rails_filter], nil).prefix)
        .to eq(I18n.t('skill_search.global.no_match'))
    end

    it 'includes the department name when given' do
      expect(described_class.new([rails_filter], departments(:sys).id).prefix)
        .to eq(I18n.t('skill_search.global.no_match_with_department', department: '/sys'))
    end
  end

  describe '#groups' do
    it 'returns a single group for AND-only filters' do
      message = described_class.new([rails_filter, bash_filter], nil)
      expect(message.groups).to eq([['Rails (3/4)', 'Bash (5/2)']])
    end

    it 'splits into multiple groups on OR filters' do
      or_rails_filter = SkillSearch::SearchFilter.new(skills(:rails).id, 3, 4, :or)
      message = described_class.new([or_rails_filter, bash_filter], nil)
      expect(message.groups).to eq([['Rails (3/4)'], ['Bash (5/2)']])
    end
  end
end
