class ChangeSwitzerlandToSchweiz < ActiveRecord::Migration[5.2]
  def change
    Person.find_each do |person|
      person.origin = 'Schweiz'
      person.save!
    end
  end
end
