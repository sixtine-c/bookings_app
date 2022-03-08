class Api::V1::BookingsController < Api::V1::BaseController
  before_action :set_bookings, only: [:show, :update, :destroy]
  before_action :find_mission_checkin, only: [:update, :destroy]
  before_action :find_mission_checkout, only: [:update, :destroy]

  require 'uri'
  require 'net/http'
  require 'json'

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

      update_checkin_mission_from_bookings if (@mission_checkin[:date] != @booking[:start_date] && @mission_checkin[:mission_type] == "first_checkin")
      update_checkout_mission_from_bookings if (@mission_checkout[:date] != @booking[:end_date] && @mission_checkout[:mission_type] == "last_checkout")
    else
      render_error
    end
  end

  def destroy
    delete_mission_from_booking
    @booking.destroy
    head :no_content
  end

  private

  def set_bookings
    @booking = Booking.find(params[:id])
  end

  def find_mission_checkin
    @mission_checkin = Mission.find_by(listing_id: @booking[:listing_id], date: @booking[:start_date])
  end

  def find_mission_checkout
    @mission_checkout = Mission.find_by(listing_id: @booking[:listing_id], date: @booking[:end_date])
  end

  def create_mission_from_bookings
    @listing = Listing.find(params[:listing_id])
    price_checkin = 10 * @listing[:num_rooms]
    price_checkout = 5 * @listing[:num_rooms]

    # checkin
    body = {listing_id: @booking[:listing_id], mission_type: 'first_checkin', date: @booking[:start_date], price: price_checkin }.to_json
    http_request_post(body)

    # checkout
    body = {listing_id: @booking[:listing_id], mission_type: 'last_checkout', date: @booking[:end_date], price: price_checkout }.to_json
    http_request_post(body)
  end

  def http_request_post(body)
    uri = URI('http://localhost:3000/api/v1/missions')
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = body
    http.request(req)
  end

  def update_checkin_mission_from_bookings
    url = "http://localhost:3000/api/v1/missions/#{@mission_checkin.id}"
    body = {date: @booking[:start_date]}.to_json
    http_request_patch(url, body)
  end

  def update_checkout_mission_from_bookings
    url = "http://localhost:3000/api/v1/missions/#{@mission_checkout.id}"
    body = {date: @booking[:end_date]}.to_json
    http_request_patch(url, body)
  end

  def http_request_patch(url, body)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Patch.new(uri.path, 'Content-Type' => 'application/json')
    req.body = body
    http.request(req)
  end

  def delete_mission_from_booking
    # delete checkin
    url = "http://localhost:3000/api/v1/missions/#{@mission_checkin.id}"
    http_request_delete(url)
    # delete checkout
    url = "http://localhost:3000/api/v1/missions/#{@mission_checkout.id}"
    http_request_delete(url)
  end

  def http_request_delete(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Delete.new(uri)
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
