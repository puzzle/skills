require 'rails_helper'

describe SkillSearch::SearchFilters do
  def params(overrides = {})
    { skill_ids: nil, levels: nil, interests: nil, operators: nil, department: nil }.merge(overrides)
  end

  def people_skill(skill_id:, level: 3, interest: 3)
    instance_double(PeopleSkill, skill_id: skill_id, level: level, interest: interest)
  end

  describe '.parse' do
    it 'creates a SearchFilter for each row' do
      filters = described_class.parse(params(
        skill_ids: [1, 2], levels: [3, 4], interests: [2, 3]
      )).filters

      expect(filters.length).to eq(2)
      expect(filters).to all(be_a(SkillSearch::SearchFilter))
    end

    it 'starts with no filters when params are empty' do
      expect(described_class.parse(params).filters).to be_empty
    end
  end

  describe '#add_row' do
    it 'appends a blank filter row' do
      subject = described_class.parse(params)
      expect { subject.add_row }.to change { subject.count }.by(1)
    end
  end

  describe '#delete_row' do
    it 'removes the filter at the given index' do
      subject = described_class.parse(params)
      subject.add_row
      subject.add_row
      expect { subject.delete_row(0) }.to change { subject.count }.by(-1)
    end
  end

  describe '#no_matches?' do
    it 'is false when there are no applicable filters' do
      subject = described_class.parse(params)
      subject.add_row
      expect(subject).not_to be_no_matches
    end

    it 'is true when filters were applied but nothing matched' do
      subject = described_class.parse(params(
        skill_ids: [999], levels: [1], interests: [1]
      ))
      subject.apply { |_ids| {} }
      expect(subject).to be_no_matches
    end

    it 'is false when results were found' do
      subject = described_class.parse(params(
        skill_ids: [1], levels: [1], interests: [1]
      ))
      person = instance_double(Person)
      subject.apply { |_ids| { person => [people_skill(skill_id: 1)] } }
      expect(subject).not_to be_no_matches
    end
  end

  describe '#apply' do
    it 'yields the applicable skill_ids to the block' do
      subject = described_class.parse(params(
        skill_ids: [1, 2], levels: [1, 1], interests: [1, 1]
      ))
      yielded = nil
      subject.apply { |ids| yielded = ids; {} }
      expect(yielded).to eq([1, 2])
    end

    it 'returns empty and does not yield when no applicable filters exist' do
      subject = described_class.parse(params)
      subject.add_row
      yielded = false
      result = subject.apply { yielded = true; {} }
      expect(result).to eq([])
      expect(yielded).to be false
    end

    it 'keeps only people whose skills match all filters in a group' do
      subject = described_class.parse(params(
        skill_ids: [1, 2], levels: [1, 1], interests: [1, 1]
      ))
      person_a = instance_double(Person)
      person_b = instance_double(Person)
      subject.apply do |_ids|
        {
          person_a => [people_skill(skill_id: 1), people_skill(skill_id: 2)],
          person_b => [people_skill(skill_id: 1)]
        }
      end
      expect(subject.results.keys).to eq([person_a])
    end
  end
end
