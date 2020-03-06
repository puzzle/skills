class DropCompanyOfferLocationEmployeeQuantity < ActiveRecord::Migration[6.0]
  def change
    drop_table :locations
    drop_table :offers
    drop_table :employee_quantities

    remove_foreign_key :people, :companies

    drop_table :companies
  end
end
