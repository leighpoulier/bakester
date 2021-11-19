class Category < ApplicationRecord
  has_many :bakes
  validates :name, presence: true

  def self.filter_options
    Category.order(:name).map {|c| [c.name, c.id]}.prepend(["All", nil])
  end

end
