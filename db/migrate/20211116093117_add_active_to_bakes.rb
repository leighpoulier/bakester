class AddActiveToBakes < ActiveRecord::Migration[6.1]
  def change
    add_column :bakes, :active, :boolean, default: true, null: false

  end
end
