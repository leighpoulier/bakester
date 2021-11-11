class AdminController < ApplicationController

  before_action :authenticate_user!
  before_action :is_admin?

  def admin
  end


  # private
  #   def is_admin?
  #     if !user_signed_in? || !current_user.admin
  #       redirect_to :root
  #     end
  #   end
end
