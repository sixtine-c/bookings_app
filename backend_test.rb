@input = {
  listings: [
    { id: 1, num_rooms: 2 },
    { id: 2, num_rooms: 1 },
    { id: 3, num_rooms: 3 }
  ],
  bookings: [
    { id: 1, listing_id: 1, start_date: "2016-10-10", end_date: "2016-10-15" },
    { id: 2, listing_id: 1, start_date: "2016-10-16", end_date: "2016-10-20" },
    { id: 3, listing_id: 2, start_date: "2016-10-15", end_date: "2016-10-20" }
  ],
  reservations: [
    { id: 1, listing_id: 1, start_date: "2016-10-11", end_date: "2016-10-13" },
    { id: 1, listing_id: 1, start_date: "2016-10-13", end_date: "2016-10-15" },
    { id: 1, listing_id: 1, start_date: "2016-10-16", end_date: "2016-10-20" },
    { id: 3, listing_id: 2, start_date: "2016-10-15", end_date: "2016-10-18" }
  ]
}
