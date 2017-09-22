class AddCompanyToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :company, :string
  end
end
