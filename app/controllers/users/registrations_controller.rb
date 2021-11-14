# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :is_admin?, except: [:show, :upgrade, :upgrade_to_baker, :edit_password, :update_password, ]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  def show
    id = params[:id]
    @user = User.find(id)
  end

  def upgrade
  end


  def upgrade_to_baker
    if user_signed_in? 
      if !current_user.baker && params[:user][:baker] == "true"
        current_user.baker = true
        current_user.baker_at = DateTime.now
        if current_user.save
          redirect_to :mybakes
        else
          flash.alert "Unable to upgrade to baker for some reason...?"
          redirect_to :root
        end
      else
        redirect_to :root
      end
    else
      redirect_to :root
    end
  end

  def edit_password
  end

  def update_password
  end

  def index
    @users = User.all
  end

  def upgrade_to_admin
    @user.update_attribute(:admin, true)
  end

  

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private
  def resource_name
    :user
  end

  def resource
    current_user
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
