class AddNationalityToPerson < ActiveRecord::Migration[5.1]

  def up
    add_column :people, :nationality, :string
    add_column :people, :nationality2, :string
    remove_column :people, :origin
  end

  def down
    add_column :people, :origin, :string

    Person.find_each do |p|
      connection = ActiveRecord::Base.connection
      nationalities = connection.execute "SELECT nationality, nationality2 FROM people WHERE id = #{p.id}"
      origin = nationalities.values[0][0].to_s
      origin += ", " + nationalities.values[0][1].to_s unless nationalities.values[0][1].nil?
      connection.execute "UPDATE people SET origin = '#{origin}' WHERE id = #{p.id}"
    end

    remove_column :people, :nationality
    remove_column :people, :nationality2
  end

end
