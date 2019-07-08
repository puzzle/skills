class CreateSynchronizeJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :synchronize_jobs do |t|
      t.string :name
      t.timestamp :last_runned_at

      t.timestamps
    end
  end
end
