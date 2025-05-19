class AddPtimeDataProviderToPeople < ActiveRecord::Migration[8.0]
  def change
    add_column :people, :ptime_data_provider, :string
  end
end
