class AddUnitCountToBakes < ActiveRecord::Migration[6.1]
  def change
    add_column :bakes, :unit_count, :integer, default: 1, null: false
  end
end
