# == Schema Information
#
# Table name: skills
#
#  id          :bigint(8)        not null, primary key
#  title       :string
#  radar       :integer
#  portfolio   :integer
#  default_set :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Skill do
  context 'validations' do
    it 'should not have a title with more than 100 characters' do
      skill = Skill.new
      skill.title = SecureRandom.hex(150)
      skill.valid?

      expect(skill.errors[:title].first).to eq('ist zu lang (mehr als 100 Zeichen)')
    end

    it 'should have a title' do
      skill = Skill.new
      skill.valid?

      expect(skill.errors[:title].first).to eq('muss ausgefüllt werden')
    end
  end
end
