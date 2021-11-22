class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

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

end
