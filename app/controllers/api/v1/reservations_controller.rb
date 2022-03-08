class Api::V1::ReservationsController < Api::V1::BaseController
  before_action :set_reservations, only: %i[show update destroy]
  before_action :find_checkout_checkin_mission, only: %i[update destroy]

  def index
    @reservations = Reservation.all
  end

  def show
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      render :show
      @listing = Listing.find_by(id: @reservation[:listing_id])

      @listing.bookings.each do |booking|
        if @reservation[:end_date] >= booking[:start_date] && @reservation[:end_date] < booking[:end_date]
          create_mission_from_reservations
        end
      end
    else
      render_error
    end
  end

  def update
    if @reservation.update(reservation_params)
      render :show, status: :created

      update_checkin_checkout_mission if @mission_checkout_checkin[:date] != @reservation[:end_date]
    else
      render_error
    end
  end

  def destroy
    @reservation.destroy
    head :no_content
    delete_mission_from_reservation
  end

  private

  def set_reservations
    @reservation = Reservation.find(params[:id])
  end

  def find_checkout_checkin_mission
    @mission_checkout_checkin = Mission.find_by(listing_id: @reservation[:listing_id], date: @reservation[:end_date])
  end

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :listing_id)
  end

  def render_error
    render json: { errors: @reservation.errors.full_messages },
           status: :unprocessable_entity
  end

  def create_mission_from_reservations
    price_checkout_checkin = 10 * @listing[:num_rooms]

    body = { listing_id: @reservation[:listing_id], mission_type: 'checkout_checkin', date: @reservation[:end_date],
             price: price_checkout_checkin }.to_json
    http_request_post(body)
  end

  def update_checkin_checkout_mission
    url = "http://localhost:3000/api/v1/missions/#{@mission_checkout_checkin.id}"
    body = { date: @reservation[:end_date] }.to_json
    http_request_patch(url, body)
  end

  def delete_mission_from_reservation
    url = "http://localhost:3000/api/v1/missions/#{@mission_checkout_checkin.id}"
    http_request_delete(url)
  end
end
