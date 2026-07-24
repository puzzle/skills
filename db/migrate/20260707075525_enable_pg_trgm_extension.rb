class EnablePgTrgmExtension < ActiveRecord::Migration[8.1]
  def up
    enable_extension 'pg_trgm'
  end

  def down
    # It has to be empty because we don't want to disable the extension during the rollback.
  end
end
