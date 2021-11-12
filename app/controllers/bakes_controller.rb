class BakesController < ApplicationController
  before_action :set_bake, only: %i[ show edit update destroy purge_image ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorise_user, except: [:index, :show, :new, :create, :my_bakes]
  before_action except: [:index, :show, :my_bakes, :new, :create] do
    is_admin_or_owner?(@bake)
  end

  def index
    @bakes = Bake.all
  end

  def my_bakes
    @bakes = current_user.bakes
  end

  def show
    @bake.increment!(:view_count)
  end

  def new
    @bake = current_user.bakes.new
  end

  def create
    
    if params[:bake][:bake_image_upload]
      resize_image
    end
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
    if params[:bake][:bake_image_upload]
      resize_image
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

  def purge_image
    @bake.image.purge
    render :edit
  end

  private

  def set_bake
    @bake = Bake.find(params[:id])
  end

  def authorise_user
    unless current_user.id == @bake.baker.id || current_user.admin
      # flash.notice = "You're not allowed to do that"
      redirect_to :root
    end
  end

  def bake_params
    params.require(:bake).permit(:name, :description, :unit, :category_id, :lead_time_days, :image)
  end

  def set_unit_price
    if params[:unit_price_dollars]
      @bake.update_attribute(:unit_price, (params[:unit_price_dollars].to_f * 100).to_i)
    end
  end

  def resize_image
    uploaded_image = params[:bake][:bake_image_upload]
    uploaded_image_path = Pathname.new(uploaded_image)
    image = MiniMagick::Image.new(uploaded_image_path)
    image.resize "#{Bake::IMAGE_UPLOAD_MAX_WIDTH}x#{Bake::IMAGE_UPLOAD_MAX_HEIGHT}>"
    
    if image.data["geometry"]["width"] <= Bake::IMAGE_UPLOAD_MAX_WIDTH && image.data["geometry"]["height"] <= Bake::IMAGE_UPLOAD_MAX_HEIGHT
      params[:bake][:image] = params[:bake][:bake_image_upload]
      params[:bake].delete(:bake_image_upload)
    else
      @bake.errors.add(:image, "Image resizing failed !")
      render :edit, status: :unprocessable_entity
    end

  end




end
