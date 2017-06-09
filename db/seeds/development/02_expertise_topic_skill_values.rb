# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'expertise_topic_skill_value_seeder')

seeder = ExpertiseTopicSkillValueSeeder.new

seeder.seed_expertise_topic_skill_values
