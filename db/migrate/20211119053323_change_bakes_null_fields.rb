class ChangeBakesNullFields < ActiveRecord::Migration[6.1]
  def change
    change_column_null :bakes, :name, false
    change_column_null :bakes, :description, false
    change_column_null :bakes, :price, false
    change_column_null :bakes, :unit, false
    change_column_null :bakes, :lead_time_days, false
  end
end
