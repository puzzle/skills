class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :location
      t.string :web
      t.string :email
      t.string :phone
      t.string :partnermanager
      t.string :contact_person
      t.string :email_contact_person
      t.string :phone_contact_person
      t.string :crm
      t.string :level
      t.integer :number_MA_total
      t.integer :number_MA_dev
      t.integer :number_MA_sys_mid
      t.integer :number_MA_PL
      t.integer :number_MA_UX

      t.timestamps
    end
  end
end
