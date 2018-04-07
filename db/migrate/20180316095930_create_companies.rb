class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :web
      t.string :email
      t.string :phone
      t.string :partnermanager
      t.string :contact_person
      t.string :email_contact_person
      t.string :phone_contact_person
      t.string :crm
      t.string :level
      t.boolean :my_company

      t.timestamps
    end
  end
end
