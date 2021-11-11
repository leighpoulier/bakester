class ChangeOrdersToBakeOrders < ActiveRecord::Migration[6.1]
  def change
    rename_table :orders, :bake_orders
  end
end
