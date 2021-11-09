class BakesController < ApplicationController
  before_action :set_bake, only: %i[ show edit update destroy ]

  # GET /bakes
  def index
    @bakes = Bake.all
  end

  # GET /bakes/:id
  def show
  end

  # GET /bakes/new
  def new
    @bake = Bake.new
  end

  # POST /bakes
  def create
    @bake = Bake.new(bake_params)

    if @bake.save
      redirect_to @bake, notice: "Bake was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /bakes/:id/edit
  def edit
  end

  # PUT/PATCH /bakes/:id
  def update
    if @bake.update(bake_params)
      redirect_to @bake, notice: "Bake was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bake
    @bake = Bake.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def bake_params
    params.require(:bake).permit(:name, :description, :unit_price, :unit, :category_id, :view_count, :lead_time_days)
  end
end
