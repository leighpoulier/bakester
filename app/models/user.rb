class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :timeoutable, timeout_in: 30.minutes

  has_many :bakes, foreign_key: :baker_id
  has_many :bake_jobs, through: :bakes

  has_many :bake_orders

  # has_many :incoming_bake_orders, through: :bake_jobs, source: :bake_order

  validates :first_name, :last_name, presence: true

  scope :bakers, ->  {where(baker: true) }

  def full_name
    self.first_name + " " + self.last_name
  end

end
