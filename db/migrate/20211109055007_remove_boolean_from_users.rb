class RemoveBooleanFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :boolean
  end
end
