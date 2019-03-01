require 'rails_helper'
require Rails.root.join('db', 'seeds', 'support', 'category_seeder')

describe CategorySeeder do
  describe 'CategorySeeder' do
    
    describe 'Seed categories from hash' do
      it 'seeds all given categories' do
        seeder = CategorySeeder.new
        categories = {
          ParentCategory1: [
            'ChildCategory1',
            'ChildCategory2'
          ],
          'ParentCategory2': [
            'ChildCategory3',
            'ChildCategory4'
          ] 
        }
        expect do
          SeedFu.quiet = true
          seeder.seed_categories(categories)
        end.to change { Category.count }.by(6)
        categories.flatten(2).each do |category|
          expect(Category.all.map(&:title)).to include(category.to_s)
        end
      end
    end
  end
end
