class CreateOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :offers do |t|
      t.string :category
      t.text :offer, array: true, default: []
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
