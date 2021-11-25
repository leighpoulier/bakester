class BakeOrdersController < ApplicationController
  before_action :authenticate_user!, except: [:cart, :update_cart, :empty_cart]
  before_action :is_admin?, only: [:index, :users_bake_orders]
  before_action :set_filter_list, only: [:index]
  before_action :set_order, only: [:show]
  before_action :set_cart, only: [:cart, :checkout, :empty_cart, :update_cart, :add_to_cart]
  before_action except: [:index, :my_bake_orders, :cart, :update_cart, :empty_cart, :users_bake_orders] do
    is_admin_or_owner?(@bake_order)
  end
  after_action :set_return, only: [:index, :my_bake_orders, :users_bake_orders, :cart]
  before_action :set_return_instance, only: [:show, :edit, :update_cart]

  def index
    byebug
    filter = params[:filter]
    case filter
    when 'all'
      @bake_orders = BakeOrder.eager_loading.all
    when 'submitted'
      @bake_orders = BakeOrder.eager_loading.submitted
    when 'in_cart'
      @bake_orders = BakeOrder.eager_loading.carts
    else
      @bake_orders = BakeOrder.eager_loading.all
    end
  end

  def my_bake_orders
    @bake_orders = current_user.bake_orders.eager_loading
  end

  def users_bake_orders
    @user = User.find(params[:user_id])
    @bake_orders = @user.bake_orders.eager_loading
  end

  def show
  end

  def cart
  end


  def update_cart
    if params[:bake_order]
      if user_signed_in?
        # params already formed, do what they say (direct edit bake_order)
        @cart.update(bake_order_params)
        redirect_to :cart
      else
        flash.alert "Unable to update cart bake order - no user signed in"
        redirect_to :bakes
      end
    else
      if params[:bake_id]  # params contains a bake_id, assume it needs adding to cart
        bake_id = params[:bake_id]
        if params[:quantity] && params[:quantity].to_i.is_a?(Integer)
          quantity = params[:quantity].to_i
        else
          quantity = 1
        end
        if user_signed_in?
          if bake_job = @cart.bake_jobs.where(bake_id: bake_id).first  #already exists in cart
            bake_job.increment!(:quantity, quantity )
            flash.notice = "#{quantity && quantity > 1 ? "#{quantity} " : "" }#{bake_job.bake.name} added to cart"
          elsif @cart.save && bake_job = @cart.bake_jobs.create(bake_id: bake_id, quantity:  quantity  ) #add to cart
            flash.notice = "#{quantity && quantity > 1 ? "#{quantity} " : "" }#{bake_job.bake.name} added to cart"
          else 
            flash.alert = "Unable to add #{Bake.find(bake_id).name} to cart ?"
          end
        else
          if session[:cart][bake_id]  #  if it already exists
            session[:cart][bake_id] += quantity  #increment by quantity
            unless @return && @return == '/cart'
              flash.notice = "#{quantity && quantity > 1 ? "#{quantity} " : "" }#{Bake.find(bake_id).name} added to cart"
            end
          else  # if it doesn't exist
            session[:cart][bake_id] = quantity  # add the quantity to cart
            unless @return && @return == '/cart'
              flash.notice = "#{quantity && quantity > 1 ? "#{quantity} " : "" }#{Bake.find(bake_id).name} added to cart"
            end
          end
          if session[:cart][bake_id] < 1 || params[:delete]
            session[:cart].delete(bake_id)
          end
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
            bake_job.update_attribute(:price_at_order, bake_job.bake.price)
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
    if user_signed_in?
      @cart.destroy
    else
      session.delete(:cart)
      @session_cart = nil
    end
    redirect_to :root
  end

  private

  def set_cart
    puts "SET CART"
    if user_signed_in?
      puts "USER SIGNED IN - CART SET"
      @cart = current_user.cart
      @bake_order = @cart
    else
      puts "NO USER SIGNED IN - NO CART SET"
      session[:cart] ||= {}
      @session_cart = session[:cart]
    end
  end

  def set_order
    puts "SET ORDER"
    @bake_order = BakeOrder.find(params[:id])
  end


  def bake_order_params
    params.require(:bake_order).permit(:bake_jobs_attributes).permit(:bake_id, :quantity, :status)
  end

  def set_filter_list
    @filter_list = ["all", "submitted", "in_cart"]
  end
end
