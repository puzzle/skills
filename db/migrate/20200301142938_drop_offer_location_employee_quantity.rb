class DropOfferLocationEmployeeQuantity < ActiveRecord::Migration[6.0]
  def change
    drop_locations_offers_employee_quantities
    remove_columns_on_company
  end

  private

  def drop_locations_offers_employee_quantities
    drop_locations
    drop_offers
    drop_employee_quantities
  end

  def remove_columns_on_company
    change_table(:companies) do |t|
      t.remove :web
      t.remove :email
      t.remove :phone
      t.remove :partnermanager
      t.remove :contact_person
      t.remove :email_contact_person
      t.remove :phone_contact_person
      t.remove :offer_comment
      t.remove :crm
      t.remove :level
      t.remove :company_type
      t.remove :associations_updated_at
    end
  end

  def drop_locations
    drop_table :locations do |t|
      t.string :location
      t.belongs_to :company, foreign_key: true

      t.timestamps
    end
  end

  def drop_offers
    drop_table :offers do |t|
      t.string :category
      t.text :offer, array: true, default: []
      t.references :company, foreign_key: true

      t.timestamps
    end
  end

  def drop_employee_quantities
    drop_table :employee_quantities do |t|
      t.string :category
      t.integer :quantity
      t.belongs_to :company, foreign_key: true

      t.timestamps
    end
  end
end
