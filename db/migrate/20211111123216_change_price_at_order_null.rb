class ChangePriceAtOrderNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :bake_jobs, :price_at_order, true
  end
end
