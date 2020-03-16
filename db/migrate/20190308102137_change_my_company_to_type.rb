class ChangeMyCompanyToType < ActiveRecord::Migration[5.2]
  # Stub the model as it has been removed from the codebase
  class Company < ActiveRecord::Base
  end

  def up
    add_column :companies, :company_type, :integer, default: 3, null: false

    Company.reset_column_information

    Company.find_each do |company|
      company.company_type = company.my_company ? 0 : 3
      company.save!
    end

    remove_column :companies, :my_company, :boolean
  end

  def down
    add_column :companies, :my_company, :boolean, default: false

    Company.reset_column_information

    Company.find_each do |company|
      company.my_company = company.company_type_before_type_cast == 0
      company.save!
    end

    remove_column :companies, :company_type, :integer
  end
end
