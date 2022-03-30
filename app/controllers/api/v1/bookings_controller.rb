class Api::V1::BookingsController < Api::V1::BaseController
  before_action :set_bookings, only: %i[show update destroy]
  before_action :find_mission_checkin, only: %i[update destroy]
  before_action :find_mission_checkout, only: %i[update destroy]

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
      if @mission_checkin[:date] != @booking[:start_date] && @mission_checkin[:mission_type] == "first_checkin"
        update_checkin_mission_from_bookings
      end
      if @mission_checkout[:date] != @booking[:end_date] && @mission_checkout[:mission_type] == "last_checkout"
        update_checkout_mission_from_bookings
      end
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
    Mission.create!(listing_id: @booking[:listing_id], mission_type: 'first_checkin', date: @booking[:start_date],
                price: price_checkin)

    # checkout
    Mission.create!(listing_id: @booking[:listing_id], mission_type: 'last_checkout', date: @booking[:end_date],
                    price: price_checkout)
  end

  def update_checkin_mission_from_bookings
    @mission_checkin.update(date: @booking[:start_date])
  end

  def update_checkout_mission_from_bookings
    @mission_checkout.update(date: @booking[:end_date])
  end

  def delete_mission_from_booking
    # delete checkin
    @mission_checkin.destroy
    # delete checkout
    @mission_checkout.destroy
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :listing_id)
  end

  def render_error
    render json: { errors: @booking.errors.full_messages },
           status: :unprocessable_entity
  end
end
