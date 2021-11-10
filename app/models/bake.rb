# class BakeImageValidator < ActiveModel::Validator
#   def validate(bake)
#     if bake.image.size > 5.megabytes
#       bake.errors.add :image, "Maximum image size is 5MB"
#     end
#     if !['image/png', 'image/jpg', 'image/jpeg', 'image/webp'].include?(bake.image.content_type)
#       bake.errors.add :image, "Permitted image types are JPG, PNG, and WEBP"
#     end
#   end
# end

class Bake < ApplicationRecord

  IMAGE_TYPES = ['image/png', 'image/jpg', 'image/jpeg', 'image/webp']
  IMAGE_MAX_SIZE = 1.megabytes

  belongs_to :user
  belongs_to :category

  validates :name, :description, :unit_price, :unit, :category_id, :lead_time_days, :user_id, presence: true
  validates :unit_price, :lead_time_days, numericality: {only_integer: true}
  validates :image, blob: { content_type: Bake::IMAGE_TYPES, size_range: 0..(Bake::IMAGE_MAX_SIZE) }

  has_one_attached :image

  def unit_price_dollars
    self.unit_price / 100.0
  end

end