class MoveImagesToFileSystem < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :profile_picture, :binary
    add_column :people, :picture, :string
  end
end
