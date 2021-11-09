class ChangeUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.remove :baker?
      t.boolean :baker, :boolean, default: false

    end

  end
end
