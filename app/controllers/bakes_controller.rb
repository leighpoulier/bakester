class BakesController < ApplicationController
  before_action :set_bake, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]



  def index
    @bakes = Bake.all
  end

  def mybakes
    @bakes = current_user.bakes
  end

  def show
    @bake.increment!(:view_count)
  end

  def new
    @bake = current_user.bakes.new
  end

  def create
    
    @bake = current_user.bakes.new(bake_params)
    
    set_unit_price

    if @bake.save
      redirect_to @bake, notice: "Bake was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update

    if params[:bake_remove_image]
      @bake.image.purge
    end

    set_unit_price


    if @bake.update(bake_params)
      redirect_to @bake, notice: "Bake was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bake.destroy
    redirect_to bakes_url, notice: "Bake was successfully deleted."

  end

  private

  def set_bake
    @bake = Bake.find(params[:id])
  end

  def bake_params
    params.require(:bake).permit(:name, :description, :unit, :category_id, :lead_time_days, :image)
  end

  def set_unit_price
    if params[:unit_price_dollars]
      @bake.update_attribute(:unit_price, (params[:unit_price_dollars].to_f * 100).to_i)
    end
  end

  # def upload_pic
  #   if uploaded_file = params[:bake][:image]
      
  #     # Save locally BAD
  #     # pathname = Rails.root.join 'public','images',uploaded_file.original_filename
  #     # File.open(pathname, 'wb') do |file|
  #     #   file.write uploaded_file.read
  #     # end
  #     # @recipe.update_attribute :picture_url, uploaded_file.original_filename

  #     # Upload to AWS
  #     if uploaded_file.size <= 5.megabytes
  #       if ['image/png', 'image/jpg', 'image/jpeg', 'image/webp'].include?(uploaded_file.content_type)
  #         @bake.image.attach(params[:bake][:image])
  #         return true
  #       else
  #         @bake.errors.add(:image, "Permitted image types are JPG and PNG")
  #         return false
  #       end
  #     else
  #       @bake.errors.add(:image, "Maximum image size is 5MB")
  #       return false
  #     end

  #     # uuid = SecureRandom.uuid   # Version 4 UUID
  #   else
  #     return true  # there is no file to upload, so this is success.
  #   end
  # end
end
