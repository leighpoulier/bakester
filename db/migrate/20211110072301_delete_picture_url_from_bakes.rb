class DeletePictureUrlFromBakes < ActiveRecord::Migration[6.1]
  def change
    remove_column :bakes, :picture_url
  end
end
