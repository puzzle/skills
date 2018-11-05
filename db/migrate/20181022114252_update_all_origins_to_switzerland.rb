class UpdateAllOriginsToSwitzerland < ActiveRecord::Migration[5.2]
  def change
    Person.find_each do |person|
      person.origin = 'Switzerland'
      person.save!
    end
  end
end
