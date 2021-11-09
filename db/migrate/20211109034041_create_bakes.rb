class CreateBakes < ActiveRecord::Migration[6.1]
  def change
    create_table :bakes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.integer :unit_price
      t.string :unit
      t.references :category, null: false, foreign_key: true
      t.integer :view_count
      t.integer :lead_time_days

      t.timestamps
    end
  end
end
