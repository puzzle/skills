class AddPictureUrlToPeople < ActiveRecord::Migration[8.1]
  def change
    add_column :people, :picture_url, :string
  end
end
