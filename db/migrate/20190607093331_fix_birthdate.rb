class FixBirthdate < ActiveRecord::Migration[5.2]
  # Because this is a data correction, we only write an up method in this migration
  def up
    Person.includes(:company).find_each do |person|
      if (person.birthdate.time.hour != 0) 
        correct_birthdate = person.birthdate.time.change(hour: 0)
        correct_birthdate += 1.days
        person.update_column(:birthdate, correct_birthdate)
      end
    end
  end
end
