# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  after_action :synchronise_cart, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end


  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if params[:return] && params[:return] != ""
        "#{params[:return]}"
      elsif resource.is_a?(User) && resource.admin
        admin_path
      elsif resource.is_a?(User) && resource.baker
        my_bakes_path
      else
        super
      end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def synchronise_cart

    if user_signed_in? && session[:cart] && session[:cart].values.sum > 0

      # get the users's cart
      cart = current_user.cart

      session[:cart].each do |bake_id, quantity|
        if quantity > 0
          # if the cart already contains bake job for this bake
          if bake_job = cart.bake_jobs.where(bake_id: bake_id).first
            # increment the bake job
            bake_job.increment!(:quantity, quantity)
          
          else # no bake job for this bake
            # create the bake job
            begin
              cart.transaction do
                cart.save
                cart.bake_jobs.create(bake_id: bake_id, quantity: quantity)
                cart.save!
              end
            rescue
              flash.alert "Unable to synchronise cart on login"
            #else
            end
          end

        end
      end

      session.delete(:cart)
    
    end
  end

end
