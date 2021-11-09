class Bake < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :name, :description, :unit_price, :unit, :category_id, :lead_time_days, :user_id, presence: true
  validates :unit_price, :lead_time_days, numericality: {only_integer: true}

end
