# == Schema Information
#
# Table name: expertise_topics
#
#  id                    :integer          not null, primary key
#  name                  :string
#  user_topic            :boolean          default(FALSE)
#  expertise_category_id :integer
#

require 'rails_helper'

describe ExpertiseTopic do
  context 'validations' do
    it 'checks presence of name' do
      et = ExpertiseTopic.new

      et.valid?

      expect(et.errors[:name].first).to eq('muss ausgefüllt werden')
    end

    it 'checks length of name' do
      et = ExpertiseTopic.new(name: SecureRandom.hex(100))

      et.valid?

      expect(et.errors[:name].first).to eq('ist zu lang (mehr als 100 Zeichen)')
    end

    it 'checks uniqueness of name' do
      et = ExpertiseTopic.new(name: 'ruby on rails', 
                              expertise_category: expertise_categories(:ruby))

      et.valid?

      expect(et.errors[:name].first).to eq('ist bereits vergeben')
    end
  end
end
