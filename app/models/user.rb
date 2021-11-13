class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :timeoutable, timeout_in: 30.minutes

  has_many :bakes, foreign_key: :baker_id

  # excluding the incomplete/unsubmitted order "cart"
  has_many :bake_orders, -> {where(submitted: true)}

  # excluding those bake_jobs with where the bake_order is unsubmitted
  has_many :bake_jobs, ->{ joins(:bake_order).where( bake_order: {submitted: true }) }, through: :bakes

  validates :first_name, :last_name, presence: true

  scope :bakers, ->  {where(baker: true) }

  def full_name
    self.first_name + " " + self.last_name
  end

  def cart
    self.bake_orders.where(submitted: false).first
  end

  def cart_size
    if self.cart
      return self.cart&.bake_jobs&.sum(:quantity)
    else
      return 0
    end
  end

end
