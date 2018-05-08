class MigrateStatusToCompany < ActiveRecord::Migration[5.1]
def up
    #STATUSES = { 1 => 'Mitarbeiter',
    #             2 => 'Ex Mitarbeiter',
    #             3 => 'Bewerber',
    #             4 => 'Partner' }.freeze
    
    employees = Company.create!(name: 'Firma')
    ex_employees = Company.create!(name: 'Ex-Mitarbeiter')
    candidates = Company.create!(name: 'Bewerber')
    partner = Company.create!(name: 'Partner')
 

    Person.find_each do |person|
      case person.status_id
      when 1
        person.update!(company: employees)
      when 2
        person.update!(company: ex_employees)
      when 3
        person.update!(company: candidates)
      when 4
        person.update!(company: partner)
      else
        person.update!(company: nil)
      end
    end
  end

  def down
    remove_column :people, :status_id
  end
end
