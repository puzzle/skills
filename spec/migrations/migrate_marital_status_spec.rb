require 'rails_helper'
migration_file_name = Dir[Rails.root.join('db/migrate/20181126123058_migrate_marital_status.rb')].first
require migration_file_name

describe MigrateMaritalStatus do

  let(:migration) { MigrateMaritalStatus.new }

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

    it 'changes martial status to marital status' do
      migration.up

      expect(people(:bob).marital_status).to eq('single')
      expect(people(:alice).marital_status).to eq('married')
    end
  end
  
  context 'down' do
    after { migration.up }

    it 'changes marital status to martial status' do
      migration.down

      expect(people(:bob).martial_status).to eq('ledig')
      expect(people(:alice).martial_status).to eq('verheiratet')
    end
  end
end
