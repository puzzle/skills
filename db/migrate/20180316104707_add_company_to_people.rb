class AddCompanyToPeople < ActiveRecord::Migration[5.1]
  def change
    add_reference :people, :company, foreign_key: true
  end
end
