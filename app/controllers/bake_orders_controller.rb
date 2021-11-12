class BakeOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin?, only: [:index]
  before_action :set_order, only: [:show]
  before_action :set_cart, only: [:cart, :checkout, :empty_cart, :update_cart, :add_to_cart]
  before_action except: [:index, :my_bake_orders] do
    is_admin_or_owner?(@bake_order)
  end

  def index
    @bake_orders = BakeOrder.all
  end

  def my_bake_orders
    @bake_orders = current_user.submitted_bake_orders
  end

  def show
  end

  def cart
  end


  def update_cart
    if params[:bake_order]
      # params already formed, do what they say
      @cart.update(bake_order_params)
      render :cart
    else
      if params[:bake_id]  # params contains a bake_id, assume it needs adding to cart
        if @bake_job = @cart.bake_jobs.where(bake_id: params[:bake_id]).first  #already exists in cart
          @bake_job.increment!(:quantity)
        else #add to cart
          unless @cart.save && @cart.bake_jobs.create(bake_id: params[:bake_id])
            flash.alert = "Unable to add to cart ?"
          end
        end
      end
    end
    render :cart
  end

  def checkout
    @cart.bake_jobs.each do |bake_job|
      bake_job.update_attribute(:price_at_order, bake_job.bake.unit_price)
      bake_job.update_attribute(:status, :confirmed)
    end
    if @cart.valid? && @cart.bake_jobs.any?
      @cart.update_attribute(:submitted_at, DateTime.now)
      @cart.update_attribute(:submitted, true)
      redirect_to @cart
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
    @cart = current_user.bake_orders.where(submitted: false).first || current_user.bake_orders.new
    @bake_order = @cart
  end

  def set_order
    puts "SET ORDER"
    @bake_order = BakeOrder.find(params[:id])
  end


  def bake_order_params
    params.require(:bake_order).permit(:bake_jobs_attributes).permit(:bake_id, :quantity, :status)
  end

end
