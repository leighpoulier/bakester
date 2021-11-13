# class BakeOrderValidator < ActiveModel::Validator

#   def validate(bake_order)
#     unless bake_order.bake_jobs.any?
#       bake_order.errors.add :base, "Order cannot be empty"
#     end
#   end
  
# end

class BakeOrder < ApplicationRecord
  belongs_to :user
  has_many :bake_jobs, dependent: :destroy
  has_many :bakes, through: :bake_jobs
  has_many :bakers, through: :bakes

  validates_associated :bake_jobs
  # validates_with BakeOrderValidator
  validates :submitted_at, presence: true, if: :submitted

  scope :submitted, -> { where(submitted: true) }

  accepts_nested_attributes_for :bake_jobs, reject_if: ->(attributes){ attributes['quantity'] < 0 || attributes['status'] < 0 }, allow_destroy: true

  def owners
    [ self.user ]
  end

end
