class BakeOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin?, only: [:index]
  before_action :set_order, only: [:show]
  before_action :set_cart, only: [:cart, :checkout, :empty_cart, :update_cart, :add_to_cart]
  before_action except: [:index, :my_bake_orders] do
    is_admin_or_owner?(@bake_order)
  end

  def index
    filter = params[:filter]
    case filter
    when 'all'
      @bake_orders = BakeOrder.all
    when 'submitted'
      @bake_orders = BakeOrder.submitted
    when 'in_cart'
      @bake_orders = BakeOrder.carts
    else
      @bake_orders = BakeOrder.all
    end
  end

  def my_bake_orders
    @bake_orders = current_user.bake_orders
  end

  def show
  end

  def cart
  end


  def update_cart
    if params[:bake_order]
      # params already formed, do what they say (direct edit bake_order)
      @cart.update(bake_order_params)
      redirect_to :cart
    else
      if params[:bake_id]  # params contains a bake_id, assume it needs adding to cart
        if bake_job = @cart.bake_jobs.where(bake_id: params[:bake_id]).first  #already exists in cart
          bake_job.increment!(:quantity)
          flash.notice = "Added #{bake_job.bake.name} to cart"
        elsif @cart.save && bake_job = @cart.bake_jobs.create(bake_id: params[:bake_id]) #add to cart
          flash.notice = "Added #{bake_job.bake.name} to cart"
        else 
          flash.alert = "Unable to add to cart ?"
        end
      end
      redirect_to_context
    end
  end

  def checkout
    if @cart.bake_jobs.any?
      begin
        @cart.transaction do
          @cart.bake_jobs.each do |bake_job|
            bake_job.update_attribute(:price_at_order, bake_job.bake.unit_price)
            bake_job.update_attribute(:status, :received)
          end
          @cart.update_attribute(:submitted_at, DateTime.now)
          @cart.update_attribute(:submitted, true)
          @cart.save!
        end
      rescue
        render :cart
      else
        redirect_to @cart
      end
    else
      render :cart
    end
  end

  def empty_cart
    @cart.destroy
    redirect_to :root
  end

  private

  def set_cart
    puts "SET CART"
    @cart = current_user.cart
    @bake_order = @cart
  end

  def set_order
    puts "SET ORDER"
    @bake_order = BakeOrder.find(params[:id])
  end


  def bake_order_params
    params.require(:bake_order).permit(:bake_jobs_attributes).permit(:bake_id, :quantity, :status)
  end


  def redirect_to_context
    case params[:context]
    when 'bakes'
      redirect_to :bakes
    else
      redirect_to :cart
    end
  end
end
