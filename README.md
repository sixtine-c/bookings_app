Backend test
We are building a listing rentals management company; let’s call it HostnFly ;)

4 main objects populate our app:

listings: apartments of our clients
bookings: periods of time during which our clients leave us their apartment
reservations: periods of time during which a guest rents one of our apartments
mission: cleaning an apartment
bookings, reservations and missions all BELONG to listing (they all have a listing_id) but are not otherwise directly related to one another.

Here is our plan to clean the apartment, at any time:

We should have a cleaning mission called first_checkin at the beginning of the booking
We should have a cleaning mission called last_checkout before the owner comes back
We should have a cleaning mission called checkout_checkin at the end of each reservation UNLESS there is already a last_checkout at the same date
Reservation and Bookings could be cancelled, in this case we should not do missions related.

We negotiated the prices with our cleaning partner:

a first checkin costs 10€ per room
a checkout checkin costs 10€ per room
a last checkout costs 5€ per room
Here is the input json

{
  "listings": [
    { "id": 1, "num_rooms": 2 },
    { "id": 2, "num_rooms": 1 },
    { "id": 3, "num_rooms": 3 }
  ],
  "bookings": [
    { "id": 1, "listing_id": 1, "start_date": "2016-10-10", "end_date": "2016-10-15" },
    { "id": 2, "listing_id": 1, "start_date": "2016-10-16", "end_date": "2016-10-20" },
    { "id": 3, "listing_id": 2, "start_date": "2016-10-15", "end_date": "2016-10-20" }
  ],
  "reservations": [
    { "id": 1, "listing_id": 1, "start_date": "2016-10-11", "end_date": "2016-10-13" },
    { "id": 2, "listing_id": 1, "start_date": "2016-10-13", "end_date": "2016-10-15" },
    { "id": 3, "listing_id": 1, "start_date": "2016-10-16", "end_date": "2016-10-20" },
    { "id": 4, "listing_id": 2, "start_date": "2016-10-15", "end_date": "2016-10-18" }
  ]
}
Goal
You need to create a Rails Application using Active records which has:

Service that generates missions from Listing/Booking/Reservation models
JSON API:
CRUD on listing / bookings / reservations
Index endpoints to revrieve missions created
Script to fill the database from the backend_test.rb
Note: no authentication is required

If you think about useful business rules you can add some.

The output JSON should resemble this

{
  "missions": [
    {:listing_id=>1, :mission_type=>"first_checkin", :date=>"2016-10-10", :price=>20},
    {:listing_id=>1, :mission_type=>"last_checkout", :date=>"2016-10-15", :price=>10},
    {:listing_id=>1, :mission_type=>"first_checkin", :date=>"2016-10-16", :price=>20},
    {:listing_id=>1, :mission_type=>"last_checkout", :date=>"2016-10-20", :price=>10},
    {:listing_id=>1, :mission_type=>"checkout_checkin", :date=>"2016-10-13", :price=>20},
    {:listing_id=>2, :mission_type=>"first_checkin", :date=>"2016-10-15", :price=>10},
    {:listing_id=>2, :mission_type=>"last_checkout", :date=>"2016-10-20", :price=>5},
    {:listing_id=>2, :mission_type=>"checkout_checkin", :date=>"2016-10-18", :price=>10}
  ]
}
Go slowly, and write code that could be easily extensible and clean.

CURL

Listings

Create:
curl -i -X POST \
     -H 'Content-Type: application/json'    \
     -d '{ "listing": { "num_rooms": 1 } }' \
     http://localhost:3000/api/v1/listings


Update:
curl -i -X PATCH \
       -H 'Content-Type: application/json' \
       -d '{  "num_rooms": 4 }'\
       http://localhost:3000/api/v1/listings/4

Delete:
curl -i -X DELETE                               \
     http://localhost:3000/api/v1/listings/5


Bookings

Create:
curl -i -X POST \
     -H 'Content-Type: application/json'    \
     -d '{ "listing_id": 1 ,"start_date": "2016-12-14", "end_date": "2016-12-21" }' \
     http://localhost:3000/api/v1/bookings


Update:
curl -i -X PATCH \
       -H 'Content-Type: application/json' \
       -d '{  "start_date": "2016-12-15" }'\
       http://localhost:3000/api/v1/bookings/21

Delete:
curl -i -X DELETE                               \
     http://localhost:3000/api/v1/bookings/23


Reservations

Create:
curl -i -X POST \
     -H 'Content-Type: application/json'    \
     -d '{ "reservation": { "listing_id": 7 ,"start_date": "2016-11-03", "end_date": "2016-11-11" } }' \
     http://localhost:3000/api/v1/reservations


Update:
curl -i -X PATCH \
       -H 'Content-Type: application/json' \
       -d '{  "end_date": "2016-11-14" }'\
       http://localhost:3000/api/v1/reservations/4

Delete:
curl -i -X DELETE                               \
     http://localhost:3000/api/v1/reservations/4

-reverifier les request de bookings
-créer request reservations
-comment enlever missions quand booking annulé ?
-dans seed, créer les premières missions
