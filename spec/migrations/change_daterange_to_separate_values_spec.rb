require 'rails_helper'
migration_file_name = Dir[Rails.root.join('db/migrate/20190318091758_change_daterange_to_separate_values.rb')].first
require migration_file_name

describe ChangeDaterangeToSeparateValues do

  let(:migration) { ChangeDaterangeToSeparateValues.new }
  let(:project) { projects(:google) }
  let(:education) { educations(:bsc) }

  def silent
    verbose = ActiveRecord::Migration.verbose = false
    # disabling Bullet here because we
    # enabled it to late to actually improve this migration
    Bullet.enable = false

    yield

    Bullet.enable = true
    ActiveRecord::Migration.verbose = verbose
  end

  around do |test|
    silent { test.run }
  end

  context 'up' do

    before { migration.down }

    it 'changes to separate values' do
      migration.up

      expect(project.year_from).to eq(2012)
      expect(project.month_from).to eq(nil)
      expect(project.year_to).to eq(2015)
      expect(project.month_to).to eq(nil)
      expect(education.year_from).to eq(2000)
      expect(education.month_from).to eq(nil)
      expect(education.year_to).to eq(2010)
      expect(education.month_to).to eq(nil)
    end
  end

  context 'down' do
    after { migration.up }

    it 'changes to date attributes' do
      migration.down

      expect(project.finish_at).to eq(Date.parse('2015-12-13'))
      expect(project.start_at).to eq(Date.parse('2012-1-13'))
      expect(education.finish_at).to eq(Date.parse('2010-12-13'))
      expect(education.start_at).to eq(Date.parse('2000-1-13'))
    end
  end
end
