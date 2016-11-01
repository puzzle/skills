# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ENV['FIXTURES_PATH'] = 'spec/fixtures'
Rake.application['db:fixtures:load'].invoke

fixtures = Rails.root.join('db', 'seeds')
SeedFu.seed ENV['NO_ENV'] ? [fixtures] : [fixtures, File.join(fixtures, Rails.env)]
