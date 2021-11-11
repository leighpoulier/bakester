class BakeOrder < ApplicationRecord
  belongs_to :user
  has_many :bake_jobs
  has_many :bakes, through: :bake_jobs
  has_many :bakers, through: :bakes

end
