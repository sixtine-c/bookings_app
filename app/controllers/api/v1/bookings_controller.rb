class Api::V1::BookingsController < Api::V1::BaseController
  before_action :set_bookings, only: [:show, :update, :destroy]

  def index
    @bookings = Booking.all
  end

  def show
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      render :show

      create_mission_from_bookings
    else
      render_error
    end
  end

  def update
    if @booking.update(booking_params)
      render :show, status: :created
    else
      render_error
    end
  end

  def destroy
    @booking.destroy
    head :no_content
  end

  private

  def set_bookings
    @booking = Booking.find(params[:id])
  end

  def create_mission_from_bookings
    @listing = Listing.find(params[:listing_id])
    price_checkin = 10 * @listing[:num_rooms]
    price_checkout = 5 * @listing[:num_rooms]
    require 'uri'
    require 'net/http'
    require 'json'
    # checkin
    uri = URI('http://localhost:3000/api/v1/missions')
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = {listing_id: @booking[:listing_id], mission_type: 'first_checkin', date: @booking[:start_date], price: price_checkin }.to_json
    http.request(req)
    # puts "response #{res.body}"

    # checkout
    req.body = {listing_id: @booking[:listing_id], mission_type: 'last_checkout', date: @booking[:end_date], price: price_checkout }.to_json
    http.request(req)
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :listing_id)
  end

  def render_error
    render json: { errors: @booking.errors.full_messages },
           status: :unprocessable_entity
  end
end
