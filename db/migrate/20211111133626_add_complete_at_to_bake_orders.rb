class AddCompleteAtToBakeOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :bake_orders, :complete_at, :datetime, precision: 6
  end
end
