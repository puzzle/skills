require 'rails_helper'
migration_file_name = Dir[Rails.root.join('db/migrate/20181120072351_change_year_to_date_range.rb')].first
require migration_file_name

describe ChangeYearToDateRange do

  let(:migration) { ChangeYearToDateRange.new }
  let(:project) { projects(:google) }
  let(:education) { educations(:bsc) }

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

    it 'changes columns to start_at and finish_at' do
      migration.up

      expect(project.finish_at).to eq(Date.parse('2015-12-13'))
      expect(project.start_at).to eq(Date.parse('2012-1-13'))
      expect(education.finish_at).to eq(Date.parse('2010-12-13'))
      expect(education.start_at).to eq(Date.parse('2000-1-13'))
    end
  end

  context 'down' do
    after { migration.up }

    it 'changes columns to year_to and year_from' do
      migration.down

      expect(project.year_from).to eq(2012)
      expect(project.year_to).to eq(2015)
      expect(education.year_from).to eq(2000)
      expect(education.year_to).to eq(2010)
    end
  end
end
