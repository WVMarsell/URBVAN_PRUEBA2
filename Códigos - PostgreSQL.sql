CREATE TABLE PUBLIC.driver_table(
	driver_id INTEGER PRIMARY KEY, 
	created_at TIMESTAMPTZ, 
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	birthdate DATE, 
	gender VARCHAR(6)
); 

COPY PUBLIC.driver_table FROM 'C:\Users\52552\Documents\DATOS\CHAMBA\URBVAN\PRUEBA_2\driver_table.csv' DELIMITER ',' CSV HEADER;



CREATE TABLE PUBLIC.client_table(
	client_id INTEGER PRIMARY KEY, 
	created_at TIMESTAMPTZ, 
	first_name VARCHAR(50), 
	last_name VARCHAR(50), 
	birth_date DATE, 
	gender VARCHAR(50)
); 

COPY PUBLIC.client_table FROM 'C:\Users\52552\Documents\DATOS\CHAMBA\URBVAN\PRUEBA_2\client_table_1.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE PUBLIC.trip_table(
	trip_id INTEGER PRIMARY KEY, 
	driver_id INTEGER, 
	on_sale_at TIMESTAMPTZ, 
	departure_at TIMESTAMPTZ, 
	arrival_at TIMESTAMPTZ, 
	vehicle_capacity INTEGER,
	seat_price FLOAT, 
	route_name TEXT,
	line_name TEXT, 
	route_type TEXT,
	FOREIGN KEY (driver_id) REFERENCES driver_table(driver_id)
); 

COPY PUBLIC.trip_table FROM 'C:\Users\52552\Documents\DATOS\CHAMBA\URBVAN\PRUEBA_2\trip_table.csv' DELIMITER ',' CSV HEADER;



CREATE TABLE PUBLIC.reservation_table(
	reservation_id INTEGER PRIMARY KEY, 
	trip_id INTEGER, 
	client_id INTEGER, 
	created_at TIMESTAMPTZ, 
	seats INTEGER, 
	total_price INTEGER,
	FOREIGN KEY (client_id) REFERENCES client_table(client_id),
	FOREIGN KEY (trip_id) REFERENCES trip_table(trip_id)
); 

COPY PUBLIC.reservation_table FROM 'C:\Users\52552\Documents\DATOS\CHAMBA\URBVAN\PRUEBA_2\reservation_table.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE viajes
AS
SELECT p.trip_id, EXTRACT(month FROM p.departure_at) AS Month_1, EXTRACT(year FROM p.departure_at) AS Year_1, p.departure_at , p.arrival_at, p.route_name, p.vehicle_capacity, p.seat_price, rt.seats
FROM trip_table	AS p 
INNER JOIN reservation_table AS rt
ON p.trip_id = rt.trip_id;


CREATE TABLE viajes_Nov
AS
SELECT *
FROM viajes AS Re
WHERE Re.Month_1 = 11 AND Re.Year_1 = 2017;


CREATE TABLE Viajes_Nov_Acum
AS
SELECT trip_id, MIN(departure_at) AS departure_at, MIN(arrival_at) AS arrival_at, MIN(route_name) AS route_name, MIN(vehicle_capacity) AS vehicle_capacity, MIN(seat_price) AS seat_price, SUM(seats) AS Seats
FROM viajes_Nov
GROUP BY trip_id;

ALTER TABLE Viajes_Nov_Acum 
ADD COLUMN Revenue INTEGER;

ALTER TABLE Viajes_Nov_Acum 
ADD COLUMN Occupancy INTEGER;

UPDATE Viajes_Nov_Acum
SET Revenue = seat_price * Seats;

UPDATE Viajes_Nov_Acum
SET Occupancy = (Seats/vehicle_capacity) * 100;
