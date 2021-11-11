class BakeJob < ApplicationRecord
  belongs_to :bake_order
  belongs_to :bake
  has_one :baker, through: :bake

  enum status: [:in_cart, :confirmed, :processing, :shipped, :delivered, :cancelled]

end
