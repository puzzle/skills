# frozen_string_literal: true

require 'active_record/fixtures'
require 'database_cleaner'

if Rails.env.test?
  DatabaseCleaner.strategy = :truncation
end

class Api::TestApiController < ActionController::API

  before_action :require_test_env!

  def create
    DatabaseCleaner.start
    fixtures_load
  end

  def destroy
    DatabaseCleaner.clean
  end

  private

  # we already check this in config/routes, but just make really sure this never
  # can be called in production.
  def require_test_env!
    raise 'only available in test env' unless Rails.env.test?
  end

  def fixtures_dir
    Rails.root.join('spec/fixtures')
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
