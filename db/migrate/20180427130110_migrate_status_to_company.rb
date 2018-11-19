class MigrateStatusToCompany < ActiveRecord::Migration[5.1]

def up
    #STATUSES = { 1 => 'Mitarbeiter',
    #             2 => 'Ex Mitarbeiter',
    #             3 => 'Bewerber',
    #             4 => 'Partner' }.freeze

    employees = Company.create!(name: 'Firma', my_company: true)
    ex_employees = Company.create!(name: 'Ex-Mitarbeiter', my_company: false)
    candidates = Company.create!(name: 'Bewerber', my_company: false)
    partner = Company.create!(name: 'Partner', my_company: false)

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

    remove_column :people, :status_id
  end

  def down
    add_column :people, :status_id
  end

end
