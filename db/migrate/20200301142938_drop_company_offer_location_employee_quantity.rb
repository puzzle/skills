class DropCompanyOfferLocationEmployeeQuantity < ActiveRecord::Migration[6.0]
  def change
    drop_table :locations do |t|
      t.string :location
      t.belongs_to :company, foreign_key: true

      t.timestamps
    end

    drop_table :offers do |t|
      t.string :category
      t.text :offer, array: true, default: []
      t.references :company, foreign_key: true

      t.timestamps
    end

    drop_table :employee_quantities do |t|
      t.string :category
      t.integer :quantity
      t.belongs_to :company, foreign_key: true

      t.timestamps
    end

    revert do
      add_reference :people, :company, foreign_key:true
    end

    drop_table :companies do |t|
      t.string :name
      t.string :web
      t.string :email
      t.string :phone
      t.string :partnermanager
      t.string :contact_person
      t.string :email_contact_person
      t.string :phone_contact_person
      t.string :offer_comment
      t.string :crm
      t.string :level
      t.boolean :my_company

      t.timestamps
    end
  end
end
