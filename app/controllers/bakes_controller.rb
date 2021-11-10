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

  def resize_image(max_width, max_height)

  end

end
