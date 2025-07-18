require 'rails_helper'

RSpec.shared_examples 'a model with date range validations' do
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

    it 'kann mit gültigen Attributen erstellt und aktualisiert werden' do
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
  fixtures :educations

  let(:record) { educations(:moe) }

  it_behaves_like 'a model with date range validations'
end

describe Project do
  fixtures :projects

  let(:record) { projects(:duckduckgo) }

  it_behaves_like 'a model with date range validations'
end

describe Activity do
  fixtures :activities

  let(:record) { activities(:roche) }

  it_behaves_like 'a model with date range validations'
end

describe AdvancedTraining do
  fixtures :advanced_trainings

  let(:record) { advanced_trainings(:course) }

  it_behaves_like 'a model with date range validations'
end