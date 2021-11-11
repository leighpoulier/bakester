class CreateBakeJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :bake_jobs do |t|
      t.references :order, null: false, foreign_key: true
      t.references :bake, null: false, foreign_key: true
      t.integer :quantity, null:false, default: 1
      t.integer :price_at_order, null: false
      t.integer :status, null:false, default: 0

      t.timestamps
    end
  end
end
