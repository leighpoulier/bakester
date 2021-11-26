class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_session_cart_size
  before_action :set_new_bake_jobs
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :baker])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :baker])
  end


  private
    def is_admin?
      puts "IS ADMIN"
      unless user_signed_in? && current_user.admin
        puts "FAILED"
        redirect_to :root
      end
      puts "OK"
    end


    def is_admin_or_owner?(resource)
      puts "IS ADMIN OR OWNER"
      puts "Resource owners: #{resource.owners}"
      unless resource.owners.include?(current_user) || current_user.admin
        puts "FAILED"
        redirect_to :root
      end
      puts "OK"
    end

    def set_session_cart_size
      @session_cart_size = session[:cart] ? session[:cart].values.sum : 0
    end

    def set_return
      session[:return] = request.path
      puts "RETURN: #{session[:return]}"
    end

    def set_return_instance
      if params[:return] && params[:return] != ""
        @return = params[:return]
      elsif session[:return] && session[:return] != ""
        @return = session[:return]
      end
    end
      



  def redirect_to_context
    if params[:return] && params[:return] != ""
      puts "REDIRECT TO PARAMS: #{params[:return]}"
      redirect_to params[:return]
    elsif session[:return] && session[:return] != ""
      puts "REDIRECT TO SESSION: #{session[:return]}"
      redirect_to session[:return]
    else
      puts "REDIRECT TO CONTEXT: #{params[:context]}"
      case params[:context]
      when 'bakes'
        redirect_to :bakes
      when 'cart'
        redirect_to :cart
      when 'index'
        redirect_to :bake_jobs
      when 'my_bake_jobs'
        redirect_to :my_bake_jobs
      else
        redirect_to :cart
      end
    end
  end


  def set_new_bake_jobs
    if user_signed_in? && current_user.baker && session[:new_bake_jobs]
      new_bake_jobs_alerted = session[:new_bake_jobs_alerted] ? session[:new_bake_jobs_alerted] : 0
      @new_bake_jobs = current_user.bake_jobs.new_bake_jobs.count - new_bake_jobs_alerted
      if session[:new_bake_jobs_alerted]
        session[:new_bake_jobs_alerted] += @new_bake_jobs
      else
        session[:new_bake_jobs_alerted] = @new_bake_jobs
      end

    end
  end

end
