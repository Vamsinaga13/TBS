CREATE DATABASE TicketBookingSystem;
USE TicketBookingSystem;

CREATE TABLE  Users (
user_id INT Primary key auto_increment,
name varchar(100) Not null,
email varchar(100) unique Not null,
phone VARCHAR(15) unique Not null,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transport Modes Table
CREATE TABLE TransportModes (
    mode_id INT Primary key auto_increment,
    mode_name ENUM('Train', 'Bus', 'Flight') NOT NULL
);

-- Routes Table (For trains, buses, flights)
CREATE TABLE Routes (
    route_id INT Primary key auto_increment,
    mode_id INT,
    origin varchar(100) Not null,
    destination varchar(100) Not null,
    duration TIME Not null,
    price DECIMAL(10,2) Not null,
    FOREIGN KEY (mode_id) REFERENCES TransportModes(mode_id)
);

-- Bookings Table
CREATE TABLE Bookings (
    booking_id INT Primary key auto_increment,
    user_id INT,
    route_id INT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    travel_date DATE NOT NULL,
    status ENUM('Booked', 'Cancelled', 'Completed') DEFAULT 'Booked',
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);  

-- Payments Table
CREATE TABLE Payments (
    payment_id INT Primary key auto_increment,
    booking_id INT,
    amount DECIMAL(10,2) Not null,
    payment_status ENUM('Success', 'Failed', 'Pending') DEFAULT 'Pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);


-- Insert 10 Users
INSERT INTO Users (name, email, phone) VALUES
('Rahul Sharma', 'rahul@example.com', '9876543210'),
('Priya Singh', 'priya@example.com', '9865321470'),
('Amit Verma', 'amit@example.com', '9856327410'),
('Sneha Iyer', 'sneha@example.com', '9753124680'),
('Kiran Reddy', 'kiran@example.com', '9945123780'),
('Ananya Das', 'ananya@example.com', '9865471230'),
('Vikram Patil', 'vikram@example.com', '9726548310'),
('Sakshi Mehta', 'sakshi@example.com', '9812347650'),
('Rohan Kapoor', 'rohan@example.com', '9887654321'),
('Meera Nair', 'meera@example.com', '9845123690');

-- Insert Transport Modes
INSERT INTO TransportModes (mode_name) VALUES
('Train'), ('Bus'), ('Flight');

-- Insert 10 Routes
INSERT INTO Routes (mode_id, origin, destination, duration, price) VALUES
(1, 'Hyderabad', 'Delhi', '08:30:00', 1500.00),
(2, 'Bangalore', 'Chennai', '05:15:00', 800.00),
(3, 'Mumbai', 'Kolkata', '02:45:00', 5000.00),
(1, 'Pune', 'Mumbai', '03:00:00', 600.00),
(2, 'Jaipur', 'Agra', '04:30:00', 700.00),
(3, 'Chennai', 'Hyderabad', '02:15:00', 4000.00),
(1, 'Lucknow', 'Delhi', '06:00:00', 1200.00),
(2, 'Kolkata', 'Bhubaneswar', '04:00:00', 1000.00),
(3, 'Delhi', 'Goa', '03:30:00', 4500.00),
(1, 'Ahmedabad', 'Bangalore', '07:45:00', 1800.00);

-- Insert 10 Bookings
INSERT INTO Bookings (user_id, route_id, travel_date, status) VALUES
(1, 1, '2024-05-10', 'Booked'),
(2, 2, '2024-05-12', 'Completed'),
(3, 3, '2024-05-15', 'Cancelled'),
(4, 4, '2024-05-18', 'Booked'),
(5, 5, '2024-05-20', 'Completed'),
(6, 6, '2024-05-22', 'Booked'),
(7, 7, '2024-05-25', 'Completed'),
(8, 8, '2024-05-28', 'Booked'),
(9, 9, '2024-05-30', 'Cancelled'),
(10, 10, '2024-06-02', 'Booked');

-- Insert 10 Payments
INSERT INTO Payments (booking_id, amount, payment_status) VALUES
(1, 1500.00, 'Success'),
(2, 800.00, 'Success'),
(3, 5000.00, 'Failed'),
(4, 600.00, 'Success'),
(5, 700.00, 'Success'),
(6, 4000.00, 'Success'),
(7, 1200.00, 'Success'),
(8, 1000.00, 'Pending'),
(9, 4500.00, 'Failed'),
(10, 1800.00, 'Success');


-- 1. Retrieve all bookings with user details
SELECT b.booking_id, u.name, u.email, r.origin, r.destination, r.price, b.travel_date, b.status
FROM Bookings b
JOIN Users u ON b.user_id = u.user_id
JOIN Routes r ON b.route_id = r.route_id;

-- 2. Total revenue generated
SELECT SUM(amount) AS total_revenue FROM Payments WHERE payment_status = 'Success';

-- 3. Most popular route
SELECT r.origin, r.destination, COUNT(b.booking_id) AS total_bookings
FROM Bookings b
JOIN Routes r ON b.route_id = r.route_id
GROUP BY r.origin, r.destination
ORDER BY total_bookings DESC
LIMIT 2;

-- Find the number of bookings per transport mode
SELECT tm.mode_name, COUNT(b.booking_id) AS total_bookings
FROM Bookings b
JOIN Routes r ON b.route_id = r.route_id
JOIN TransportModes tm ON r.mode_id = tm.mode_id
GROUP BY tm.mode_name
ORDER BY total_bookings DESC;
