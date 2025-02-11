class MigrateMaritalStatus < ActiveRecord::Migration[5.2]

  def up
    add_column :people, :marital_status, :integer, default: 0, null: false

    Person.reset_column_information

    Person.find_each do |person|
      old_value = person.martial_status || 'ledig'
      person.marital_status = MARITAL_MAP[old_value.to_sym]
      person.save!
    end

    remove_column :people, :martial_status
  end

  def down
    add_column :people, :martial_status, :string

    Person.reset_column_information

    Person.find_each do |person|
      old_value = Person.marital_statuses[person.marital_status]
      person.update(martial_status: MARITAL_MAP.keys[old_value])
    end

    remove_column :people, :marital_status
  end

  private

  MARITAL_MAP = { ledig: :single,
                  verheiratet: :married,
                  verwitwet: :widowed,
                  'eingetragene Partnerschaft': :registered_partnership,
                  geschieden: :divorced }

  class Person < ApplicationRecord
    enum :marital_status, %i[single married widowed registered_partnership divorced]
  end
end
