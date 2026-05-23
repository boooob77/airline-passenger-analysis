create database Airline;

--TEST
SELECT * FROM aircrafts_data;
SELECT * FROM airports_data;
SELECT * FROM boarding_passes;
SELECT * FROM bookings;
SELECT * FROM flights;
SELECT * FROM reviews;
SELECT * FROM seats;
SELECT * FROM ticket_flights;
SELECT * FROM tickets;

-- edit data type

ALTER TABLE aircrafts_data
ALTER COLUMN aircraft_code NVARCHAR(100) NOT NULL;
ALTER TABLE airports_data
ALTER COLUMN airport_code NVARCHAR(100) NOT NULL;
ALTER TABLE boarding_passes
ALTER COLUMN ticket_no NVARCHAR(100) NOT NULL;
ALTER TABLE boarding_passes
ALTER COLUMN flight_id INT NOT NULL;
ALTER TABLE bookings
ALTER COLUMN book_ref NVARCHAR(100) NOT NULL;
ALTER TABLE bookings
ALTER COLUMN total_amount BIGINT NOT NULL;
ALTER TABLE flights
ALTER COLUMN flight_id INT NOT NULL;
ALTER TABLE flights
ALTER COLUMN departure_airport NVARCHAR(100) NOT NULL;
ALTER TABLE flights
ALTER COLUMN arrival_airport NVARCHAR(100) NOT NULL;
ALTER TABLE flights
ALTER COLUMN aircraft_code NVARCHAR(100) NOT NULL;
ALTER TABLE reviews
ALTER COLUMN review_id INT NOT NULL;
ALTER TABLE reviews
ALTER COLUMN aircraft_code NVARCHAR(100) NOT NULL;
ALTER TABLE reviews
ALTER COLUMN departure_airport NVARCHAR(100) NOT NULL;
ALTER TABLE reviews
ALTER COLUMN flight_id INT NOT NULL;
ALTER TABLE reviews
ALTER COLUMN ticket_no NVARCHAR(100) NOT NULL;
ALTER TABLE ticket_flights
ALTER COLUMN ticket_no NVARCHAR(100) NOT NULL;
ALTER TABLE ticket_flights
ALTER COLUMN flight_id INT NOT NULL;
ALTER TABLE seats
ALTER COLUMN aircraft_code NVARCHAR(100)  NOT NULL;
ALTER TABLE seats
ALTER COLUMN seat_no NVARCHAR(100) NOT NULL;
ALTER TABLE tickets
ALTER COLUMN ticket_no NVARCHAR(100) NOT NULL;
ALTER TABLE tickets
ALTER COLUMN book_ref NVARCHAR(100) NOT NULL;


-- add primary key

ALTER TABLE aircrafts_data ADD PRIMARY KEY (aircraft_code);
ALTER TABLE airports_data ADD PRIMARY KEY (airport_code);
ALTER TABLE boarding_passes ADD PRIMARY KEY (ticket_no, flight_id);
ALTER TABLE bookings ADD PRIMARY KEY (book_ref);
ALTER TABLE flights ADD PRIMARY KEY (flight_id);
ALTER TABLE reviews ADD PRIMARY KEY (review_id);
ALTER TABLE ticket_flights ADD PRIMARY KEY (ticket_no, flight_id);
ALTER TABLE seats ADD PRIMARY KEY (aircraft_code, seat_no);
ALTER TABLE tickets ADD PRIMARY KEY (ticket_no);


--FOREIGN KEY 
ALTER TABLE tickets
ADD CONSTRAINT FK_tickets_bookings 
FOREIGN KEY (book_ref) REFERENCES bookings(book_ref);


ALTER TABLE ticket_flights
ADD CONSTRAINT FK_ticket_flights_tickets 
FOREIGN KEY (ticket_no) REFERENCES tickets(ticket_no);


ALTER TABLE ticket_flights
ADD CONSTRAINT FK_ticket_flights_flights 
FOREIGN KEY (flight_id) REFERENCES flights(flight_id);


ALTER TABLE boarding_passes
ADD CONSTRAINT FK_boarding_passes_tickets 
FOREIGN KEY (ticket_no) REFERENCES tickets(ticket_no);


ALTER TABLE boarding_passes
ADD CONSTRAINT FK_boarding_passes_flights 
FOREIGN KEY (flight_id) REFERENCES flights(flight_id);

ALTER TABLE flights
ADD CONSTRAINT FK_flights_departure_airport 
FOREIGN KEY (departure_airport) REFERENCES airports_data(airport_code);

ALTER TABLE flights
ADD CONSTRAINT FK_flights_arrival_airport 
FOREIGN KEY (arrival_airport) REFERENCES airports_data(airport_code);

ALTER TABLE flights
ADD CONSTRAINT FK_flights_aircrafts 
FOREIGN KEY (aircraft_code) REFERENCES aircrafts_data(aircraft_code);

ALTER TABLE seats
ADD CONSTRAINT FK_seats_aircrafts 
FOREIGN KEY (aircraft_code) REFERENCES aircrafts_data(aircraft_code);

ALTER TABLE reviews
ADD CONSTRAINT FK_reviews_tickets 
FOREIGN KEY (ticket_no) REFERENCES tickets(ticket_no);


ALTER TABLE reviews
ADD CONSTRAINT FK_reviews_flights 
FOREIGN KEY (flight_id) REFERENCES flights(flight_id);

ALTER TABLE reviews
ADD CONSTRAINT FK_reviews_airports 
FOREIGN KEY (departure_airport) REFERENCES airports_data(airport_code);

ALTER TABLE reviews
ADD CONSTRAINT FK_reviews_aircrafts 
FOREIGN KEY (aircraft_code) REFERENCES aircrafts_data(aircraft_code);

-- Top Fare Conditions
SELECT 
    tf.fare_conditions,
    COUNT(*) AS total,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS percentage
FROM ticket_flights tf
JOIN flights f ON tf.flight_id = f.flight_id
GROUP BY tf.fare_conditions

-- Flights Distribution By Status
SELECT 
    status,
    COUNT(*) AS total_flights
FROM flights
GROUP BY status
ORDER BY total_flights DESC;

-- Top Departure Airports
SELECT TOP 10 
    departure_airport,
    COUNT(*) AS total_flights
FROM flights
GROUP BY departure_airport
ORDER BY total_flights DESC;

-- Top Routes
SELECT TOP 10
    departure_airport,
    arrival_airport,
    COUNT(*) AS total_flights
FROM flights
GROUP BY departure_airport, arrival_airport
ORDER BY total_flights DESC

-- Most Used Aircraft
SELECT TOP 10
    f.aircraft_code,
    a.model,
    COUNT(*) AS total_flights
FROM flights f
JOIN aircrafts_data a ON f.aircraft_code = a.aircraft_code
GROUP BY f.aircraft_code, a.model
ORDER BY total_flights DESC