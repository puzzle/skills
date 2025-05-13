class RemoveExpertise < ActiveRecord::Migration[8.0]
  def change
    drop_table :expertise_categories, :expertise_topics, :expertise_topic_skill_values
  end
end
