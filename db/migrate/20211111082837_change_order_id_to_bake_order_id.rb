class ChangeOrderIdToBakeOrderId < ActiveRecord::Migration[6.1]
  def change
    change_table :bake_jobs do |t|
      t.rename :order_id, :bake_order_id
    end
  end
end
