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
  IMAGE_MAX_SIZE = 5.megabytes
  IMAGE_UPLOAD_MAX_WIDTH = 500
  IMAGE_UPLOAD_MAX_HEIGHT = 500

  belongs_to :baker, class_name: "User"
  belongs_to :category
  has_many :bake_jobs
  has_many :bake_orders, through: :bake_jobs
  has_one_attached :image

  validates :name, :description, :price, :unit, :category_id, :lead_time_days, :baker_id, presence: true
  validates :price, :lead_time_days, numericality: {only_integer: true}
  validates :image, blob: { content_type: Bake::IMAGE_TYPES, size_range: 0..(Bake::IMAGE_MAX_SIZE) }

  scope :active, -> { where(active: true ) }
  scope :hidden, -> { where(active: false) }

  scope :search_field, ->(field_name, search_string) { where( "#{field_name} ILIKE ?", "%#{search_string}%" ) }
  scope :search_name_split, ->(search_string) {
    search_term_array = search_string.split(" ")
    relation = all
    search_term_array.each do |search_term|
      relation = relation.search_field('name', search_term)
    end
    return relation
  }
  scope :filter_price_range, ->(from,to) { where(price: from...to ) }

  def price_dollars
    self.price / 100.0
  end

  def unit_price_dollars
    self.price / 100.0 / self.unit_count
  end

  def owners
    [ self.baker ]
  end

end