class ChangeYearToDateRange < ActiveRecord::Migration[5.2]

  def up
    tables = [:projects, :activities, :advanced_trainings, :educations]
    tables.each do |table|
      add_column table, :finish_at, :date
      add_column table, :start_at, :date
      klazz = table.to_s.classify.constantize
      klazz.reset_column_information
      klazz.find_each do |e|
        currentTable = table.to_s
        connection = ActiveRecord::Base.connection

        if e.year_to == nil || e.year_to == 0 then
          connection.execute "UPDATE #{currentTable} SET finish_at = null WHERE #{currentTable}.id = #{e.id}"
        else
          connection.execute "UPDATE #{currentTable} SET finish_at = '#{e.year_to}-12-13' WHERE #{currentTable}.id = #{e.id}"
        end

        connection.execute "UPDATE #{currentTable} SET start_at = '#{e.year_from}-1-13' WHERE #{currentTable}.id = #{e.id}"
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
        currentTable = table.to_s
        connection = ActiveRecord::Base.connection

        if e.finish_at == nil then
          connection.execute "UPDATE #{currentTable} SET year_to = null WHERE #{currentTable}.id = #{e.id}"
        else
          connection.execute "UPDATE #{currentTable} SET year_to = #{e.finish_at.year} WHERE #{currentTable}.id = #{e.id}"
        end

        connection.execute "UPDATE #{currentTable} SET year_from = #{e.start_at.year} WHERE #{currentTable}.id = #{e.id}"

      end
      remove_column table, :start_at
      remove_column table, :finish_at
    end
  end
end
