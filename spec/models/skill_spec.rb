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
#  category_id :bigint(8)
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
      expect(skill.errors[:category].first).to eq('muss ausgefüllt werden')
    end

    it 'should not have same named skills with the same category' do
      skill = Skill.new
      skill.title = 'Rails'
      skill.category = Category.all[3]
      skill.valid?

      expect(skill.errors[:title].first).to eq('ist bereits vergeben')
    end
    
    it 'could have same named skills with different category' do
      skill = Skill.new
      skill.title = 'Rails'
      skill.category = Category.all[1]
      skill.valid?

      expect(skill.errors[:base].first).to eq(nil)
    end
  end
end
