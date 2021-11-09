class BakesController < ApplicationController
  before_action :set_bake, only: %i[ show edit update destroy ]

  def index
    @bakes = Bake.all
  end

  def mybakes
    @bakes = current_user.bakes
  end

  def show
    @bake.view_count.increment
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
    redirect_to bakes_url, notice: "Bake was successfully destroyed."

  end

  private

  def set_bake
    @bake = Bake.find(params[:id])
  end

  def bake_params
    params.require(:bake).permit(:name, :description, :unit_price, :unit, :category_id, :lead_time_days)
  end
end
