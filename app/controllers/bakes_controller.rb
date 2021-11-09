class BakesController < ApplicationController
  before_action :set_bake, only: %i[ show edit update destroy ]

  def index
    @bakes = Bake.all
  end

  def show
  end

  def new
    @bake = Bake.new
  end

  def create
    @bake = Bake.new(bake_params)

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
    params.require(:bake).permit(:name, :description, :unit_price, :unit, :category_id, :view_count, :lead_time_days)
  end
end
