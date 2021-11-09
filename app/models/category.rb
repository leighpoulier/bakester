class Category < ApplicationRecord
  has_many :bakes
  validates :name, presence: true
end
