require 'rails_helper'
migration_file_name = Dir[Rails.root.join('db/migrate/20190607093331_fix_birthdate.rb')].first
require migration_file_name

describe FixBirthdate do

  let(:migration) { FixBirthdate.new }
  let(:bob) { people(:bob) }

  def silent
    verbose = ActiveRecord::Migration.verbose = false
    yield

    ActiveRecord::Migration.verbose = verbose
  end

  around do |test|
    silent { test.run }
  end

  context 'up' do

    before(:each) do
      sign_in auth_users(:admin)
    end

    it 'increments day and sets hour to 0' do
      bob.birthdate = bob.birthdate.time.change(hour: 22)
      bob.birthdate = bob.birthdate.change(day: 20)
      bob.save!

      migration.up

      bob.reload

      expect(bob.birthdate.time.hour).to eq(0)
      expect(bob.birthdate.day).to eq(21)
    end

    it 'increments day correctly to next month' do
      bob.birthdate = bob.birthdate.time.change(hour: 22)
      bob.birthdate = bob.birthdate.change(day: 30)
      bob.birthdate = bob.birthdate.change(month: 6)
      bob.save!

      migration.up

      bob.reload

      expect(bob.birthdate.time.hour).to eq(0)
      expect(bob.birthdate.day).to eq(1)
      expect(bob.birthdate.month).to eq(7)
    end
  end
end
