class ChangeStatusDefaultInOrders < ActiveRecord::Migration[6.1]
  def change
    change_column_default :orders, :complete, from: nil, to: false
  end
end
