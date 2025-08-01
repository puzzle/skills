require 'rails_helper'

RSpec.shared_examples 'a model validating date ranges' do
  context 'validations' do
    it 'does not allow year_from to be blank' do
      instance = described_class.new
      instance.valid?
      expect(instance.errors[:year_from].first).to eq('muss ausgefüllt werden')
    end

    it 'allows year_to to be blank' do
      record.year_to = nil
      record.valid?
      expect(record.errors[:year_to]).to be_empty
    end

    it 'allows month_to to be blank' do
      record.month_to = nil
      record.valid?
      expect(record.errors[:month_to]).to be_empty
    end

    it 'does not create if year_from is later than year_to' do
      record.year_from = record.year_to + 1
      record.valid?
      expect(record.errors[:year_from].first).to eq('muss vor dem Enddatum sein.')
    end

    it 'is valid and updatable with correct date attributes' do
      expect(record[:year_from]).to eq(2010)
      expect(record[:month_from]).to eq(12)

      record.update(year_from: 2022)
      record.update(month_from: 11)

      expect(record[:year_from]).to eq(2022)
      expect(record[:month_from]).to eq(11)
    end
  end
end


describe Education do
  let(:record) { educations(:moe) }

  it_behaves_like 'a model validating date ranges'
end

describe Project do
  let(:record) { projects(:duckduckgo) }

  it_behaves_like 'a model validating date ranges'
end

describe Activity do
  let(:record) { activities(:roche) }

  it_behaves_like 'a model validating date ranges'
end

describe AdvancedTraining do
  let(:record) { advanced_trainings(:course) }

  it_behaves_like 'a model validating date ranges'
end