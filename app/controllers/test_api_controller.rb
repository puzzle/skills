require 'active_record/fixtures'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

class TestApiController < ActionController::API
  def create
    DatabaseCleaner.start
    fixtures_load
  end

  def destroy
    DatabaseCleaner.clean
  end

  private

  def fixtures_dir
    Rails.root.join('spec', 'fixtures')
  end

  def fixtures_files
    Dir.glob(File.join(fixtures_dir, '*.yml'))
  end

  def fixtures_load
    ActiveRecord::FixtureSet.reset_cache
    fixtures_files
      .map { |file| File.basename(file, '.*') }
      .each do |filename|
        ActiveRecord::FixtureSet.create_fixtures(fixtures_dir, filename)
      end
  end
end
