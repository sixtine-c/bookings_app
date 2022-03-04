class Api::V1::MissionsController < Api::V1::BaseController
  before_action :set_missions, only: [:show, :update, :destroy]

  # outpupath = 'lib/data/missions.json'

  def index
    @missions = Mission.all
  end

  def show
  end

  def create
    @mission = Mission.new(mission_params)
    if @mission.save
      render :show
    else
      render_error
    end
  #   Mission.destroy_all

  #   create_missions
  #   missions = []

  #   Mission.all.each do |mission|
  #     missions << {
  #         "id" => "#{mission.id}",
  #         "apartment_id" => "#{mission.apartment_id}",
  #         "mission_type" => "#{mission.mission_type}",
  #         "price" => "#{mission.price}",
  #         "date" => "#{mission.date}"
  #     }
  #   end

  # output = {
  # 'rentals' => result
  # }

  # File.open(outputpath, 'w') do |file|
  #   file.write(JSON.pretty_generate(output))
  # end

  end


  private

  def set_missions
    @mission = Mission.find(params[:id])
  end

  # def create_missions
  #   Listing.all.each do |listing|
  #     create_mission_from_bookings(listing)
  #     create_mission_from_reservation(listing)
  #   end
  # end

  # def create_mission_from_bookings(listing)
  #   listing.bookings.each do |booking|
  #     listing.missions.create!(
  #         mission_type: 'first_checkin',
  #         date: booking[:start_date],
  #         price: 10*listing[:num_rooms]
  #     )
  #   end
  #   listing.bookings.each do |booking|
  #     listing.missions.create!(
  #         mission_type: 'last_checkin',
  #         date: booking[:end_date],
  #         price: 5*listing[:num_rooms]
  #     )
  #   end
  # end

  # def create_mission_from_reservations(listing)
  #    Reservation.joins(listing: :bookings)
  #       .where('DATE(reservations.start_date) >= DATE(bookings.start_date) AND DATE(reservations.end_date) < DATE(bookings.end_date)')
  #       .where(listings: {id: listing.id})
  #       .each do |reservation|
  #     listing.missions.create!(
  #         mission_type: 'checkout_checkin',
  #         date: reservation.end_date,
  #         price: 10*listing.num_rooms
  #     )
  #       end
  # end
  def mission_params
    params.require(:mission).permit(:listing_id, :mission_type, :date, :price)
  end

  def render_error
    render json: { errors: @mission.errors.full_messages },
           status: :unprocessable_entity
  end
end
