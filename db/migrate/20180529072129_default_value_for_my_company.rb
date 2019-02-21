class DefaultValueForMyCompany < ActiveRecord::Migration[5.1]

  def change
    change_column_default :companies, :my_company, from: true, to: false
  end

end
