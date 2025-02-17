class MigrateStatusToCompany < ActiveRecord::Migration[5.1]

  # Stub the model as it has been removed from the codebase
  class Company < ActiveRecord::Base
  end

def up
    #STATUSES = { 1 => 'Mitarbeiter',
    #             2 => 'Ex Mitarbeiter',
    #             3 => 'Bewerber',
    #             4 => 'Partner' }.freeze

    employees = Company.create!(name: 'Firma', my_company: true)
    ex_employees = Company.create!(name: 'Ex-Mitarbeiter', my_company: false)
    candidates = Company.create!(name: 'Bewerber', my_company: false)
    partner = Company.create!(name: 'Partner', my_company: false)

    execute "UPDATE people SET company_id = CASE WHEN status_id = 1 THEN #{employees.id} WHEN status_id = 2 THEN #{ex_employees.id} WHEN status_id = 3 THEN #{candidates.id} WHEN status_id = 4 THEN #{partner.id} END"

    remove_column :people, :status_id
  end

  def down
    add_column :people, :status_id
  end

end
