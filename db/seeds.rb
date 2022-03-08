require_relative '../backend_test'
puts 'cleaning the db'
  Listing.destroy_all
  Booking.destroy_all
  Reservation.destroy_all
  Mission.destroy_all
puts 'database clean'

puts 'starting the seed'
@input[:listings].each do |listing|
  Listing.create(num_rooms: listing[:num_rooms])

  # create the related bookings
  bookings = @input[:bookings].select { |booking| booking[:listing_id] == listing[:id] }
  bookings.each do |booking|
    Booking.create(listing_id: booking[:listing_id], start_date: booking[:start_date], end_date: booking[:end_date])
  end

  # create the related reservations
  reservations = @input[:reservations].select { |reservation| reservation[:listing_id] == listing[:id] }
  reservations.each do |reservation|
    Reservation.create(listing_id: reservation[:listing_id], start_date: reservation[:start_date], end_date: reservation[:end_date])
  end
end
puts 'seed done 🥳'
