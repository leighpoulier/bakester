class AddBakerAtToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :baker_at, :datetime, precision: 6
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
