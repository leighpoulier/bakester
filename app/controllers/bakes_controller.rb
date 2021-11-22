class BakesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_filter_list, only: [:index, :my_bakes]
  before_action :set_bake, except: [:index, :my_bakes, :new, :create]
  before_action except: [:index, :show, :my_bakes, :new, :create] do
    is_admin_or_owner?(@bake)
  end

  def index
    # filter = params[:filter]
    # if filter
    #   if current_user.admin
    #     case filter
    #     when 'all'
    #       @bakes = Bake.all
    #     when 'hidden'
    #       @bakes = Bake.hidden
    #     when 'active'
    #       @bakes = Bake.active
    #     end
    #   else
    #     redirect_to :bakes
    #   end
    # else
    #   @bakes = Bake.active
    # end
    @bakes = Bake.eager_loading.search_form(search_params)

    # Default to searching by name, for the search form.
    unless params[:search_name] || params[:search_description]
      params[:search_name] = true
    end
    if user_signed_in? && current_user.admin
      unless params[:active] || params[:hidden]
        params[:active] = true
      end
    end
  end

  def my_bakes
    # filter = params[:filter]
    # if filter == 'all'
    #   @bakes = current_user.bakes
    # elsif filter == 'hidden'
    #   @bakes = current_user.bakes.hidden
    # else
    #   @bakes = current_user.bakes.active
    # end
    @bakes = current_user.bakes.eager_loading.search_form(search_params)

    # Default to searching by name, for the search form.
    unless params[:search_name] || params[:search_description]
      params[:search_name] = true
    end

    # Default filtering to active bakes.
    unless params[:active] || params[:hidden]
      params[:active] = true
    end


  end

  def show
    @bake.increment!(:view_count)
  end

  def new
    @bake = current_user.bakes.new
  end

  def create
    
    if params[:bake][:bake_image_upload]
      resize_image
    end
    @bake = current_user.bakes.new(bake_params)
    
    set_price

    if @bake.save
      redirect_to @bake, notice: "Bake was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update

    if params[:bake_remove_image]
      @bake.image.purge
    end
    if params[:bake][:bake_image_upload]
      resize_image
    end

    set_price

    if @bake.update(bake_params)
      redirect_to @bake, notice: "Bake was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bake.destroy
    redirect_to bakes_url, notice: "Bake was successfully deleted."

  end

  def purge_image
    @bake.image.purge
    render :edit
  end

  private

  def set_bake
    @bake = Bake.eager_loading.find(params[:id])
  end


  def bake_params
    params.require(:bake).permit(:name, :description, :unit, :unit_count, :category_id, :lead_time_days, :image, :active)
  end

  def set_price
    if params[:price_dollars]
      @bake.price = (params[:price_dollars].to_f * 100).to_i
    end
  end

  def resize_image
    uploaded_image = params[:bake][:bake_image_upload]
    uploaded_image_path = Pathname.new(uploaded_image)
    image = MiniMagick::Image.new(uploaded_image_path)
    image.resize "#{Bake::IMAGE_UPLOAD_MAX_WIDTH}x#{Bake::IMAGE_UPLOAD_MAX_HEIGHT}>"
    
    if image.data["geometry"]["width"] <= Bake::IMAGE_UPLOAD_MAX_WIDTH && image.data["geometry"]["height"] <= Bake::IMAGE_UPLOAD_MAX_HEIGHT
      params[:bake][:image] = params[:bake][:bake_image_upload]
      params[:bake].delete(:bake_image_upload)
    else
      @bake.errors.add(:image, "Image resizing failed !")
      render :edit, status: :unprocessable_entity
    end

  end

  def set_filter_list
    @filter_list = ["all", "active", "hidden"]
  end

  def search_params
    puts "SEARCH PARAMS"
    if user_signed_in? && (current_user.admin || action_name == 'my_bakes')
      return params.permit(:active, :hidden, :search_text, :search_name, :search_description, :category, :sort_by, :sort_dir, :price_min, :price_max, :unit_price_min, :unit_price_max, :lead_time_min, :lead_time_max  )
    else
      return params.permit(:search_text, :search_name, :search_description, :category, :sort_by, :sort_dir, :price_min, :price_max, :unit_price_min, :unit_price_max, :lead_time_min, :lead_time_max  )
    end
  end



end
