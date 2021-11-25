class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :timeoutable, timeout_in: 30.minutes

  has_many :bakes, foreign_key: :baker_id

  # excluding the incomplete/unsubmitted order "cart"
  has_many :bake_orders, -> {where(submitted: true)}

  has_many :carts, -> {where(submitted: false).includes(bake_jobs: [:bake])}, class_name: 'BakeOrder'

  # excluding those bake_jobs with where the bake_order is not submitted (carts)
  has_many :bake_jobs, ->{ joins(:bake_order).where( bake_order: {submitted: true }) }, through: :bakes

  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true, format: /@/
  validates_uniqueness_of :email

  scope :bakers, ->  {where(baker: true) }
  scope :eager_loading, -> { includes(bakes: [:category, image_attachment: [:blob]]) }

  def full_name
    self.first_name + " " + self.last_name
  end

  def cart
    self.carts.first || self.carts.new
  end

  def cart_size
    if self.cart
      return self.cart&.bake_jobs&.sum(:quantity)
    else
      return 0
    end
  end

end
