class MigrateStatusToCompany < ActiveRecord::Migration[5.1]
  def change
    Person.find_each do |person|
      case person.status_id
      when 1
        person.update!(company_id: 1)
      when 2
        person.update!(company_id: 2)
      when 3
        person.update!(company_id: 3)
      when 4
        person.update!(company_id: 4)
      else
        person.update!(company_id: nil)
      end
    end
    remove_column :people, :status_id
  end
end
