class ChangeUserIDtoBakerIDinBakes < ActiveRecord::Migration[6.1]
  def change
    change_table :bakes do |t|
      t.rename :user_id, :baker_id
    end
  end
end
