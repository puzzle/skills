# == Schema Information
#
# Table name: expertise_topic_skill_values
#
#  id                  :integer          not null, primary key
#  years_of_experience :integer
#  number_of_projects  :integer
#  last_use            :integer
#  skill_level         :string
#  comment             :string
#  person_id           :integer
#  expertise_topic_id  :integer
#

require 'rails_helper'

describe ExpertiseTopicSkillValue do
  context 'validations' do
    it 'checks whether required attribute values are present' do
      etsv = ExpertiseTopicSkillValue.new
      etsv.valid?

      expect(etsv.errors[:years_of_experience].first).to eq(nil)
      expect(etsv.errors[:number_of_projects].first).to eq(nil)
      expect(etsv.errors[:last_use].first).to eq(nil)
      expect(etsv.errors[:skill_level].first).to eq('muss ausgefüllt werden')
      # Changed this to three since in the new rubyonrails version belongs_to's are required
      expect(etsv.errors.details.count).to eq(3)
    end

    it 'checks validation maximum length for attribute' do
      etsv = ExpertiseTopicSkillValue.new
      etsv.last_use = 12345
      etsv.comment = SecureRandom.hex(500)

      etsv.valid?

      expect(etsv.errors[:last_use].first).to eq('hat die falsche Länge (muss genau 4 Zeichen haben)')
      expect(etsv.errors[:comment].first).to eq('ist zu lang (mehr als 500 Zeichen)')
    end

    it 'checks if skill level is a valid value' do
      exception = assert_raises(ArgumentError) do
        ExpertiseTopicSkillValue.new(skill_level: 'wrong_value')
      end

      expect(exception.message).to eq("'wrong_value' is not a valid skill_level")
    end
  end

end
