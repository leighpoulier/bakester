class BakeJobsController < ApplicationController

  before_action :authenticate_user!, except: []
  before_action :is_admin?, only: [:index]
  before_action :set_bake_job, except: [:index, :my_bake_jobs, ]
  before_action except: [:index, :my_bake_jobs] do
    is_admin_or_owner?(@bake_job)
  end


  def index
    @bake_jobs = BakeJob.all
  end

  def show
    unless @bake_job.baker.id == current_user.id || @bake_job.bake_order.user.id == current_user.id || current_user.admin
      redirect_to :root
    end
  end

  def update
    if params[:bake_job]
      if @bake_job.update(bake_job_params)
        redirect_to @bake_job and return
      else
        render :edit and return
      end
    else
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
    end
    redirect_to @bake_job
  end

  def destroy
    @bake_job.destroy
    redirect_to :cart
  end

  def my_bake_jobs
    @bake_jobs = current_user.bake_jobs.pending
  end

  private

  def set_bake_job
    @bake_job = BakeJob.find(params[:id])
  end

  def bake_job_params
    params.require(:bake_job).permit(:status)
  end

end
