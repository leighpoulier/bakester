class ChangeCompleteAtToSubmittedAt < ActiveRecord::Migration[6.1]
  def change
    change_table :bake_orders do |t|
      t.rename :complete, :submitted
      t.rename :complete_at, :submitted_at
    end
  end
end
