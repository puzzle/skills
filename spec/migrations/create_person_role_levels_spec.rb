require 'rails_helper'
migration_file_name = Dir[Rails.root.join('db/migrate/20191206141247_create_person_role_level.rb')].first
require migration_file_name

describe CreatePersonRoleLevel do

  let(:migration) { CreatePersonRoleLevel.new }
  let(:bob_software_engineer) { person_roles(:bob_software_engineer) }
  let(:alice_system_engineer) { person_roles(:alice_system_engineer) }


  def silent
    verbose = ActiveRecord::Migration.verbose = false

    yield

    ActiveRecord::Migration.verbose = verbose
  end

  around do |test|
    silent { test.run }
  end

  context 'up' do
    before { migration.down }

    it 'create table person_role_levels' do
      migration.up
      expect(bob_software_engineer.person_role_level.level).to eq("S1")
      expect(alice_system_engineer.person_role_level.level).to eq("S2")
    end
  end

  context 'down' do
    after { migration.up }

    it 'deletes table person_role_levels' do
      migration.down
      expect(bob_software_engineer.level).to eq("S1")
      expect(alice_system_engineer.level).to eq("S2")
    end
  end
end
