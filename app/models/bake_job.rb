class BakeJob < ApplicationRecord
  belongs_to :bake_order
  belongs_to :bake
  has_one :baker, through: :bake

  enum status: [:in_cart, :submitted, :processing, :shipped, :delivered, :cancelled]

  validates :price_at_order, presence: true, if: -> { self.bake_order.submitted }

  def owner
    self.bake_order.user
  end

end
