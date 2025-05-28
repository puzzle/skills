# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'department_skill_snapshot_seeder.rb')

DepartmentskillSnapshotSeeder.new.seed_department_skill_snapshots