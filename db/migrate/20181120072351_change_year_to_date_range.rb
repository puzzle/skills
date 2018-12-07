class ChangeYearToDateRange < ActiveRecord::Migration[5.2]

  def up
    tables = [:projects, :activities, :advanced_trainings, :educations]
    tables.each do |table|
      add_column table, :finish_at, :date
      add_column table, :start_at, :date
      klazz = table.to_s.classify.constantize
      klazz.reset_column_information
      klazz.find_each do |e|
        update_start_at_and_finish_at(e)
      end
      remove_column table, :year_to
      remove_column table, :year_from
    end
  end

  def down
    tables = [:projects, :activities, :advanced_trainings, :educations]
    tables.each do |table|
      add_column table, :year_from, :integer
      add_column table, :year_to, :integer
      klazz = table.to_s.classify.constantize
      klazz.reset_column_information
      klazz.find_each do |e|
        revert_year_from(e)
      end
      remove_column table, :start_at
      remove_column table, :finish_at
    end
  end

  private

  def update_start_at_and_finish_at(entry)
    entry.finish_at = Date.new(entry.year_to, 12, 13)
    entry.start_at = Date.new(entry.year_from, 1, 13)
    entry.save!
  end

  def revert_year_from(entry)
    entry.year_to = entry.finish_at.year
    entry.year_from = entry.start_at.year
    entry.save!
  end
end
