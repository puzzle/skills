require Rails.root.join('db', 'seeds', 'support', 'category_seeder')

seeder = CategorySeeder.new

seeder.seed_categories(Settings.categories)
