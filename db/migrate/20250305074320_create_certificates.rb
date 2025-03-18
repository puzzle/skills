class CreateCertificates < ActiveRecord::Migration[8.0]
  def change
    create_table :certificates do |t|
      t.string :designation
      t.string :title, null: false
      t.string :provider
      t.decimal :points_value, null: false
      t.text :comment
      t.integer :course_duration
      t.integer :exam_duration
      t.string :type_of_exam
      t.integer :study_time

      t.timestamps
    end
  end
end
