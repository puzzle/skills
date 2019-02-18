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
      connection = ActiveRecord::Base.connection
      case person.status_id
      when 1
        connection.execute "UPDATE people SET company_id = #{employees.id} WHERE id = #{person.id}"
      when 2
        connection.execute "UPDATE people SET company_id = #{ex_employees.id} WHERE id = #{person.id}"
      when 3
        connection.execute "UPDATE people SET company_id = #{candidates.id} WHERE id = #{person.id}"
      when 4
        connection.execute "UPDATE people SET company_id = #{partner.id} WHERE id = #{person.id}"
      else
        connection.execute "UPDATE people SET company_id = null WHERE id = #{person.id}"
      end
    end

    remove_column :people, :status_id
  end

  def down
    add_column :people, :status_id
  end

end
