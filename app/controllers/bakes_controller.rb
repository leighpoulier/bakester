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

    if @bake.save
      redirect_to @bake, notice: "Bake was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
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
    params.require(:bake).permit(:name, :description, :unit_price, :unit, :category_id, :lead_time_days)
  end

  def upload_pic
    if uploaded_file = params[:recipe][:picture]
      
      # Save locally = NO
      # pathname = Rails.root.join 'public','images',uploaded_file.original_filename
      # File.open(pathname, 'wb') do |file|
      #   file.write uploaded_file.read
      # end

      # Upload to AWS


      # uuid = SecureRandom.uuid   # Version 4 UUID

      @recipe.update_attribute :picture_url, uploaded_file.original_filename
    end
  end
end
