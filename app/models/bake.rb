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

  scope :search_text, ->(field_name, search_string) { where( "#{field_name} ILIKE ?", "%#{search_string}%" ) }
  scope :search_text_split, ->(field_name, search_string) {
    search_term_array = search_string.split(" ")
    relation = all
    search_term_array.each do |search_term|
      relation = relation.search_text(field_name, search_term)
    end
    return relation
  }
  scope :filter_category, ->(category_id) { where(category_id: category_id)}
  scope :filter_price_range, ->(from,to) { where(price: from..to ) }
  scope :filter_unit_price_range, ->(from,to) { where("(price / unit_count) >= ?", from).where("(price / unit_count) <= ?", to) }
  scope :filter_lead_time_range, ->(from,to) {  where("lead_time_days >= ?", from).where("lead_time_days <= ?", to) }

  scope :search_form, ->(params) {
    pp params
    pp params[:hidden]
    pp params[:hidden] == true
    pp params[:hidden] == 1
    pp params[:hidden] == "1"
    if params
      if params[:hidden] && params[:hidden] == "1"
        if params[:active] && params[:active] == "1"
          puts "RELATION ALL"
          relation = all
        else
          puts "RELATION HIDDEN"
          relation = hidden
        end
      else
        puts "RELATION ACTIVE"
        relation = active
      end

      unless params[:category].nil? || params[:category].empty?
        puts "FILTERED ON CATEGORY"
        relation = relation.filter_category(params[:category])
      end

      unless params[:search_text].nil? || params[:search_text].empty?
        puts "FILTERED ON SEARCH TEXT"
        if params[:search_description] && params[:search_description] == true
          description_search = search_text_split('description',params[:search_text])
        end
        if params[:search_description].nil? || params[:search_description] == false || (params[:search_name] && params[:search_name] == true)
          name_search = search_text_split('name', params[:search_text])
        end
        if description_search
          if name_search
            puts "DESCRIPTION & NAME"
            relation = relation.and(description_search.or(name_search))
          else
            puts "DESCRIPTION ONLY"
            relation = relation.and(description_search)
          end
        else
          puts "NAME ONLY"
          relation = relation.and(name_search)
        end     
      end

      unless params[:price_min].nil? || params[:price_min].empty? || params[:price_max].nil? || params[:price_max].empty?
        puts "PRICE"
        price_min = (params[:price_min].to_f * 100).to_i
        price_max = (params[:price_max].to_f * 100).to_i
        relation = relation.filter_price_range(price_min, price_max)
      end

      unless params[:unit_price_min].nil? || params[:unit_price_min].empty? || params[:unit_price_max].nil? || params[:unit_price_max].empty?
        puts "UNIT PRICE"
        unit_price_min = (params[:unit_price_min].to_f * 100).to_i
        unit_price_max = (params[:unit_price_max].to_f * 100).to_i
        relation = relation.filter_unit_price_range(unit_price_min, unit_price_max)
      end

      unless params[:lead_time_min].nil? || params[:lead_time_min].empty? || params[:lead_time_max].nil? || params[:lead_time_max].empty?
        puts "LEAD TIME"
        # lead_time_min = (params[:lead_time_min].to_i
        # lead_time_max = (params[:lead_time_max].to_i
        relation = relation.filter_lead_time_range(params[:lead_time_min], params[:lead_time_max])
      end

      if params[:sort_by].nil? || params[:sort_by].empty?
        if params[:sort_dir].nil? || params[:sort_dir].empty?
          puts "ORDER: DEFAULT COLUMN AND DEFAULT ORDER"
          relation.order(name: :asc)
        else
          puts "ORDER: DEFAULT COLUMN"
          relation.order(name: params[:sort_dir])
        end
      else
        if params[:sort_by].nil? || params[:sort_by].empty?
          puts "ORDER: DEFAULT ORDER"
          relation.order(params[:sort_by] => :asc)
        else
          puts "ORDER: AS SPEC"
          relation.order(params[:sort_by] => params[:sort_dir])
        end
      end
    else
      puts "PARAMS EMPTY - RELATION ACTIVE"
      relation = active
    end
    
    pp relation.to_sql
    return relation

  }  









  def price_dollars
    price ? price / 100.0 : 0.0
  end

  def unit_price_dollars
    price / 100.0 / unit_count
  end

  def unit_price
    price.to_f / unit_count
  end

  def owners
    [ baker ]
  end

  def self.sort_options
    {"Name" => "name", "Price" => "price", "Unit Price" => "unit_price", "Lead Time" => "lead_time_days", "View Count" => "view_count" }
  end

end