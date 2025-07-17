require 'rails_helper'

RSpec.shared_examples 'a model with date range validations' do
  context 'validations' do
    it 'checks whether required attribute values are present' do
      instance = described_class.new
      instance.valid?
      expect(instance.errors[:year_from].first).to eq('muss ausgefüllt werden')
    end

    it 'allows year_to to be blank' do
      record.year_to = nil
      record.valid?
      expect(record.errors[:year_to]).to be_empty
    end

    it 'does not create if year_from is later than year_to' do
      record.year_from = record.year_to + 1
      record.valid?
      expect(record.errors[:year_from].first).to eq('muss vor dem Enddatum sein.')
    end
  end
end

RSpec.shared_examples 'a model that touches the associated person' do
  context 'on update' do
    it 'updates updated_at on the associated person' do
      person_updated_at = record.person.updated_at
      record.save!
      expect(record.person.reload.updated_at).to be > person_updated_at
    end
  end
end


describe Education do
  fixtures :educations

  let(:record) { educations(:bsc) }

  it_behaves_like 'a model with date range validations'
  it_behaves_like 'a model that touches the associated person'
end

describe Project do
  fixtures :projects

  let(:record) { projects(:duckduckgo) }

  it_behaves_like 'a model with date range validations'
  it_behaves_like 'a model that touches the associated person'
end

describe Project do
  fixtures :projects

  let(:record) { projects(:duckduckgo) }

  it_behaves_like 'a model with date range validations'
  it_behaves_like 'a model that touches the associated person'
end

describe Activity do
  fixtures :activities

  let(:record) { activities(:swisscom) }

  it_behaves_like 'a model with date range validations'
  it_behaves_like 'a model that touches the associated person'
end

describe Activity do
  fixtures :activities

  let(:record) { activities(:swisscom) }

  it_behaves_like 'a model with date range validations'
  it_behaves_like 'a model that touches the associated person'
end

describe AdvancedTraining do
  fixtures :advanced_trainings

  let(:record) { advanced_trainings(:course) }

  it_behaves_like 'a model with date range validations'
  it_behaves_like 'a model that touches the associated person'
end