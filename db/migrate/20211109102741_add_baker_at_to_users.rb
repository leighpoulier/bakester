class AddBakerAtToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :baker_at, :datetime, precision: 6
  end
end
