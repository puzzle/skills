require 'rails_helper'
migration_file_name = Dir[Rails.root.join('db/migrate/20191203161009_create_department.rb')].first
require migration_file_name

describe CreateDepartment do

  let(:migration) { CreateDepartment.new }
  let(:bob) { people(:bob) }
  let(:alice) { people(:alice) }
  let(:ken) { people(:ken) }


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

    it 'creates table departments' do
      migration.up
      expect(bob.department.name).to eq('/sys')
      expect(alice.department.name).to eq('/sys')
      expect(ken.department.name).to eq('/ux')
    end
  end

  context 'down' do
    after { migration.up }

    it 'drops table departments' do
      migration.down
      expect(bob['department']).to eq('/sys')
      expect(alice['department']).to eq('/sys')
      expect(ken['department']).to eq('/ux')
    end
  end
end
