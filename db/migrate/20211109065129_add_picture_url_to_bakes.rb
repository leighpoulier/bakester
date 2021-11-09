class AddPictureUrlToBakes < ActiveRecord::Migration[6.1]
  def change
    add_column :bakes, :picture_url, :string
  end
end
