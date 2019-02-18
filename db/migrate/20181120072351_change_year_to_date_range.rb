class ChangeYearToDateRange < ActiveRecord::Migration[5.2]

  def up
    tables = [:projects, :activities, :advanced_trainings, :educations]
    tables.each do |table|
      add_column table, :finish_at, :date
      add_column table, :start_at, :date
      klazz = table.to_s.classify.constantize
      klazz.reset_column_information
      klazz.find_each do |e|
        currentSchema = table.to_s
        currentSchemaSingular = currentSchema[0...-1]

        connection = ActiveRecord::Base.connection
        if e.year_to == nil || e.year_to == 0 then
          connection.execute "UPDATE #{currentSchema} SET finish_at = null WHERE #{currentSchema}.id = #{e.id}"
        else
          connection.execute "UPDATE #{currentSchema} SET finish_at = '#{e.year_to}-12-13' WHERE #{currentSchema}.id = #{e.id}"
        end

        connection.execute "UPDATE #{currentSchema} SET start_at = '#{e.year_from}-1-13' WHERE #{currentSchema}.id = #{e.id}"
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

  def revert_year_from(entry)
    entry.year_to = entry.finish_at.year
    entry.year_from = entry.start_at.year
    entry.save!
  end
end
