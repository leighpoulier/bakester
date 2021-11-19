class ChangeUnitPriceToPrice < ActiveRecord::Migration[6.1]
  def change
    change_table :bakes do |t|
      t.rename :unit_price, :price
    end
  end
end
