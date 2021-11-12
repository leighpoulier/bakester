class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :timeoutable, timeout_in: 30.minutes

  has_many :bakes, foreign_key: :baker_id

  # includes all bake_jobs, including incomplete inside "carts"
  has_many :bake_jobs, through: :bakes

  # excluding those bake_jobs with status :in_cart
  has_many :confirmed_bake_jobs, -> {where('status > ?', 0)}, through: :bakes, source: :bake_jobs
  
  # includes all orders, inluding the incomplete order "cart"
  has_many :bake_orders

  # ignoring the "cart" incomplete order
  has_many :submitted_bake_orders, -> {where(submitted: true)}, class_name: 'BakeOrder'

  # has_many :incoming_bake_orders, through: :bake_jobs, source: :bake_order

  validates :first_name, :last_name, presence: true

  scope :bakers, ->  {where(baker: true) }

  def full_name
    self.first_name + " " + self.last_name
  end

  def cart_size
    # returns nil if there is no cart
    self.bake_orders.where(submitted: false).first&.bake_jobs&.sum(:quantity)
  end

  def cart
    self.bake_orders.where(submitted: false).first
  end

end
