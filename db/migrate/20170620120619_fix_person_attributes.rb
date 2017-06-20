class FixPersonAttributes < ActiveRecord::Migration[5.1]
  def up
    change_column_default :people, :origin_person_id, nil

    Person.where(origin_person_id: -1).find_each do |p|
      p.update_column(origin_person_id: nil)
    end

    Person.where(origin_person_id: nil).find_each do |p|
      p.update_column(variation_name: nil)
    end
  end
end
