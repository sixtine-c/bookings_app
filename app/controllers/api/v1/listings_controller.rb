class Api::V1::ListingsController < Api::V1::BaseController
  before_action :set_listings, only: %i[show update destroy]

  def index
    @listings = Listing.all
  end

  def show
  end

  def create
    @listing = Listing.new(listing_params)
    if @listing.save
      render :show
    else
      render_error
    end
  end

  def update
    if @listing.update(listing_params)
      render :show, status: :created
    else
      render_error
    end
  end

  def destroy
    @listing.destroy
    head :no_content
  end

  private

  def set_listings
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:num_rooms)
  end

  def render_error
    render json: { errors: @listing.errors.full_messages },
           status: :unprocessable_entity
  end
end
