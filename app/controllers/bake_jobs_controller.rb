class BakeJobsController < ApplicationController

  before_action :authenticate_user!, except: []
  before_action :is_admin?, only: [:index, :users_bake_jobs]
  before_action :set_bake_job, except: [:index, :my_bake_jobs, :users_bake_jobs ]
  before_action :set_filter_list, only: [:index, :my_bake_jobs, :users_bake_jobs ]
  before_action except: [:index, :my_bake_jobs, :users_bake_jobs] do
    is_admin_or_owner?(@bake_job)
  end
  after_action :set_return, only: [:index, :my_bake_jobs, :users_bake_jobs]
  before_action :set_return_instance, only: [:show, :edit]

  def index
    @bake_jobs = BakeJob.eager_loading.order(:created_at)
    filter_bake_jobs
  end

  def show
    unless @bake_job.baker.id == current_user.id || @bake_job.bake_order.user.id == current_user.id || current_user.admin
      redirect_to :root
    end
  end

  def update
    if params[:bake_job] #is a normal edit to a bake_job
      if @bake_job.update(bake_job_params)
        redirect_to_context
      else
        render :edit
      end
    else # is an update to cart
      cart = @bake_job.bake_order
      if params[:increment]
        if increment = params[:increment].to_i
          @bake_job.increment!(:quantity, increment)
        end
      elsif params[:decrement]
        if decrement = params[:decrement].to_i
          @bake_job.decrement!(:quantity, decrement)
          if @bake_job.quantity < 1
            @bake_job.destroy
          end
        end
      end
      redirect_to_context
    end
  end

  def destroy
    @bake_job.destroy
    redirect_to_context

  end

  def my_bake_jobs
    @bake_jobs = current_user.bake_jobs.eager_loading.order(:submitted_at)
    filter_bake_jobs
  end

  def users_bake_jobs
    @user = User.find(params[:user_id])
    @bake_jobs = @user.bake_jobs.eager_loading.order(:submitted_at)
    filter_bake_jobs
  end

  private

  def set_bake_job
    @bake_job = BakeJob.eager_loading.find(params[:id])
  end

  def bake_job_params
    params.require(:bake_job).permit(:status)
  end

  def filter_bake_jobs
    filter = params[:filter]
    case filter
    
    when 'pending'
      @bake_jobs = @bake_jobs.pending
    when 'complete'
      @bake_jobs = @bake_jobs.complete
    when 'cancelled'
      @bake_jobs = @bake_jobs.cancelled
    when 'in_cart'
      @bake_jobs = @bake_jobs.in_cart
      
    end
  end

  def set_filter_list
    @filter_list = ["all", "pending", "complete"]
    if current_user.admin
      @filter_list.push("cancelled", "in_cart")
    end
  end


end
