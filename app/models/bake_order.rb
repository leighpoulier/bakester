# class BakeOrderValidator < ActiveModel::Validator

#   def validate(bake_order)
#     unless bake_order.bake_jobs.count > 0
#       bake_order.errors.add :base, "Order cannot be empty"
#     end
#   end
  
# end

class BakeOrder < ApplicationRecord
  belongs_to :user
  has_many :bake_jobs
  has_many :bakes, through: :bake_jobs
  has_many :bakers, through: :bakes

  validates_associated :bake_jobs
  # validates_with BakeOrderValidator
  validates :complete_at, presence: true, if: :complete

  scope :complete, -> { where(complete: true) }

end
