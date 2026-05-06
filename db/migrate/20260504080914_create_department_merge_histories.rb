class CreateDepartmentMergeHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :department_merge_histories do |t|
      t.bigint :target_department_id, null: false

      t.bigint :old_department_ids, array: true, null: false, default: []

      t.jsonb :snapshot, null: false, default: {}

      t.timestamps
    end
  end
end