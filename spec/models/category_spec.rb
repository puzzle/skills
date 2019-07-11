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

    it 'should have a unique position' do
      category = Category.new
      category.position = 100
      category.valid?

      expect(category.errors[:position].first).to eq('ist bereits vergeben')
    end
  end

  context 'orders' do
    it 'orders all_parents correctly' do
      category = Category.create!(title: 'Diverses', position: 300)

      categories = Category.all_parents
      expect(categories.first).to eq(categories(:'software-engineering'))
      expect(categories.second).to eq(categories(:'system-engineering'))
      expect(categories.third).to eq(category)
    end

    it 'orders all children correctly' do
      categories = Category.all_children
      expect(categories.first).to eq(categories(:ruby))
      expect(categories.second).to eq(categories(:java))
      expect(categories.third).to eq(categories(:'linux-engineering'))
    end

    it 'orders all skills correctly' do
      categories = Category.list.pluck(:title)
      expect(categories).to eq(['Software-Engineering', 'Ruby', 'Java', 'System-Engineering', 'Linux-Engineering'])
    end
  end
end
