require 'rails_helper'

describe SkillSearch::FilterInput do
  def params(overrides = {})
    {
      skill_ids:  [1, 2],
      levels:     [3, 4],
      interests:  [2, 3],
      operators:  [:and, :or],
      department: 5
    }.merge(overrides)
  end

  describe '#rows' do
    it 'zips skill_ids, levels, interests and operators into rows' do
      expect(described_class.new(params).rows).to eq([
        [1, 3, 2, :and],
        [2, 4, 3, :or]
      ])
    end

    it 'pads missing operators with nil so SearchFilter can default them to :and' do
      result = described_class.new(params(operators: nil)).rows
      expect(result).to eq([[1, 3, 2, nil], [2, 4, 3, nil]])
    end

    it 'returns rows even when operators length differs from skill_ids length' do
      result = described_class.new(params(operators: [:and])).rows
      expect(result).to eq([[1, 3, 2, :and], [2, 4, 3, nil]])
    end

    it 'returns empty array when skill_ids is nil' do
      expect(described_class.new(params(skill_ids: nil)).rows).to be_empty
    end

    it 'returns empty array when skill_ids, levels and interests differ in length' do
      expect(described_class.new(params(levels: [3])).rows).to be_empty
    end
  end

  describe '#department' do
    it 'returns the department value' do
      expect(described_class.new(params).department).to eq(5)
    end

    it 'returns nil when not given' do
      expect(described_class.new(params(department: nil)).department).to be_nil
    end
  end
end
