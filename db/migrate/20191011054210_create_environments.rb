class CreateEnvironments < ActiveRecord::Migration[5.2]
  def change
    drop_table :environments do

    end
    create_table :environments do |t|
      t.string :sentryDsn

      t.timestamps
    end
  end
end
