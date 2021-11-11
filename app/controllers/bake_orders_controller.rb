class BakeOrdersController < ApplicationController
  before_action :authenticate_user!, except: []
  before_action :is_admin?, except: [:show, :cart, :add_to_cart, :my_orders, :checkout]
  before_action :set_order, only: [:show]
  before_action :set_cart, only: [:cart, :add_to_cart, :checkout]

  def index
    @bake_orders = BakeOrder.all
  end

  def my_orders
    @bake_orders = current_user.complete_bake_orders
  end

  def show
    @byebug
    if current_user.id != @bake_order.user.id
      redirect_to :root
    end
  end

  def cart
  end

  def add_to_cart
    bake_id = params[:bake_id]
    if @bake_job = @cart.bake_jobs.where(bake_id: bake_id).first  #already exists in cart
      @bake_job.increment!(:quantity)
    else #add to cart
      unless @cart.save && @cart.bake_jobs.create(bake_id: bake_id)
        flash.alert = "Unable to add to cart ?"
      end
    end
    render :cart
  end

  def checkout
    @cart.bake_jobs.each do |bake_job|
      bake_job.update_attribute(:price_at_order, bake_job.bake.unit_price)
      bake_job.update_attribute(:status, :confirmed)
    end
    @cart.update_attribute(:complete_at, DateTime.now)
    @cart.update_attribute(:complete, true)
    if @cart.valid?
      byebug
      redirect_to @cart
    else
      render :cart
    end
  end

  private

  def set_cart
    @cart = current_user.bake_orders.where(complete: false).first || current_user.bake_orders.new
  end

  def set_order
    @bake_order = BakeOrder.find(params[:id])
  end

end
