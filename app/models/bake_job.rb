class BakeJobStatusValidator < ActiveModel::Validator
  def validate(bake_job)
    if bake_job.bake_order.submitted
      unless BakeJob.statuses.filter {|key,value| value !=0}.keys.include? bake_job.status
        bake_job.errors.add :status, "Status must be cancelled, received, processing, shipped, delivered for submitted orders"
      end
    else
      unless bake_job.status == :in_cart
        bake_job.errors.add :status, "status must be :in_cart or in cart orders"
      end
    end
  end
end


class BakeJob < ApplicationRecord
  belongs_to :bake_order
  belongs_to :bake
  has_one :baker, through: :bake

  enum status: {cancelled: -1, in_cart:0, received: 1, processing:2, shipped:3, delivered:4}

  validates :price_at_order, presence: true, if: -> { self.bake_order.submitted }
  validates_with BakeJobStatusValidator

  scope :in_cart, ->{where(status: 0)}
  scope :active, -> { where('status > ?', 0) }
  scope :submitted, -> { joins(:bake_order).where({bake_order:{ submitted: true }}) }
  scope :incomplete, -> { where('status < ?', 3)}
  scope :complete, -> { where('status > ?', 2)}
  scope :pending, ->{ submitted.active.incomplete }

  def owners
    [ self.baker ]
  end

end
