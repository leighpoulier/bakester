class ChangeViewCountDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :bakes, :view_count, to: 0
  end
end
