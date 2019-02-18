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
      nationality = connection.execute "SELECT nationality FROM people WHERE id = #{p.id}"
      nationality2 = connection.execute "SELECT nationality2 FROM people WHERE id = #{p.id}"
      origin = nationality.values[0][0].to_s
      origin += ", " + nationality2.values[0][0].to_s unless nationality2.values[0][0].nil?
      connection.execute "UPDATE people SET origin = '#{origin}' WHERE id = #{p.id}"
    end

    remove_column :people, :nationality
    remove_column :people, :nationality2
  end

end
