class ChangeViewCountDefault2 < ActiveRecord::Migration[6.1]
  def change
    change_column_default :bakes, :view_count, from: nil, to: 0
  end
end
