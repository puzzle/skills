# == Schema Information
#
# Table name: categories
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  parent_id  :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Category do
  context 'validations' do
    it 'should not have a title with more than 100 characters' do
      category = Category.new
      category.title = SecureRandom.hex(150)
      category.valid?

      expect(category.errors[:title].first).to eq('ist zu lang (mehr als 100 Zeichen)')
    end

    it 'should have a title' do
      category = Category.new
      category.valid?

      expect(category.errors[:title].first).to eq('muss ausgefüllt werden')
    end
  end
end
