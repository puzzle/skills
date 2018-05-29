class DefaultValueForMyCompany < ActiveRecord::Migration[5.1]

  def change
    change_column :companies, :my_company, :boolean, default: false
  end

end
