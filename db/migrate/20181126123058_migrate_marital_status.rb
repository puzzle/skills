class MigrateMaritalStatus < ActiveRecord::Migration[5.2]

  def up
    add_column :people, :marital_status, :integer, default: 0, null: false

    Person.reset_column_information

    Person.find_each do |person|
      old_value = person.martial_status || 'ledig'
      person.marital_status = MARITAL_MAP[normalize_marital(old_value)]
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

  def normalize_marital(value)
    return :ledig if value.downcase.include? "ledig"
    return :verheiratet if value.downcase.include? "verheiratet"
    return :verwitwet if value.downcase.include? "verwitwet"
    return :"eingetragene Partnerschaft" if value.downcase.include? "eingetragene Partnerschaft"
    return :geschieden if value.downcase.include? "geschieden"
    return :single
  end

  MARITAL_MAP = { ledig: :single,
                  verheiratet: :married,
                  verwitwet: :widowed,
                  'eingetragene Partnerschaft': :registered_partnership,
                  geschieden: :divorced }

  class Person < ApplicationRecord
    enum marital_status: %i[single married widowed registered_partnership divorced]
  end
end
