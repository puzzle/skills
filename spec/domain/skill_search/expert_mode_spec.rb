require 'rails_helper'

describe SkillSearch::ExpertMode do
  describe '#active?' do
    it 'is true when initialized with true' do
      expect(described_class.new(true)).to be_active
    end

    it 'is false when initialized with false' do
      expect(described_class.new(false)).not_to be_active
    end
  end

  describe '#toggle_value' do
    it 'returns "0" when active' do
      expect(described_class.new(true).toggle_value).to eq('0')
    end

    it 'returns "1" when inactive' do
      expect(described_class.new(false).toggle_value).to eq('1')
    end
  end

  describe '#limit_reached?' do
    subject { described_class.new(true) }

    it 'is true at the limit' do
      expect(subject.limit_reached?(5)).to be true
    end

    it 'is true above the limit' do
      expect(subject.limit_reached?(6)).to be true
    end

    it 'is false below the limit' do
      expect(subject.limit_reached?(4)).to be false
    end
  end

  describe '#show_operator?' do
    context 'when active' do
      subject { described_class.new(true) }

      it 'shows between rows' do
        expect(subject.show_operator?(0, 2)).to be true
      end

      it 'does not show after the last row' do
        expect(subject.show_operator?(1, 2)).to be false
      end
    end

    context 'when inactive' do
      it 'never shows' do
        expect(described_class.new(false).show_operator?(0, 2)).to be false
      end
    end
  end
end
