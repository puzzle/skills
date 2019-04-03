class ChangeDaterangeToSeparateValues < ActiveRecord::Migration[5.2]
  def up
    tables = [:projects, :activities, :advanced_trainings, :educations]
    tables.each do |table|
      add_column table, :year_from, :integer
      add_column table, :year_to, :integer
      add_column table, :month_from, :integer
      add_column table, :month_to, :integer
      klazz = table.to_s.classify.constantize
      klazz.reset_column_information
      klazz.find_each do |e|
        set_separate_attributes(e)
      end
      change_column table, :year_from, :integer, null: false
      remove_column table, :start_at
      remove_column table, :finish_at
    end
  end

  def down
    tables = [:projects, :activities, :advanced_trainings, :educations]
    tables.each do |table|
      add_column table, :finish_at, :date
      add_column table, :start_at, :date
      klazz = table.to_s.classify.constantize
      klazz.reset_column_information
      klazz.find_each do |e|
        set_start_at_and_finish_at(e)
      end
      remove_column table, :year_to
      remove_column table, :year_from
      remove_column table, :month_to
      remove_column table, :month_from
    end
  end

  def set_separate_attributes(entry)
    entry.year_from = entry.start_at.year
    entry.month_from = entry.start_at.day == 13 ? nil : entry.start_at.month
    entry.year_to = entry.finish_at.try(:year)
    entry.month_to = (entry.finish_at.nil? || entry.finish_at.day == 13) ? nil : entry.finish_at.month
    entry.save!
  end

  def set_start_at_and_finish_at(entry)
    finish_at_day = entry.month_to ? 1 : 13
    finish_at_month = entry.month_to ? entry.month_to : 12
    entry.finish_at = entry.year_to ? Date.new(entry.year_to, finish_at_month, finish_at_day) : nil
    start_at_day = entry.month_from ? 1 : 13
    start_at_month = entry.month_from ? entry.month_from : 1
    entry.start_at = Date.new(entry.year_from, start_at_month, start_at_day)
    entry.save!
  end
end
