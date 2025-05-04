-- Init.sql

-- Create the database if it doesn't already exist
CREATE DATABASE IF NOT EXISTS dev;

-- Use the created database
USE dev;

-- Create the users table if it doesn't exist
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    role VARCHAR(20)
);

-- Check if the table creation was successful
SELECT 'Table created or exists' AS status;

-- Insert data into the users table
INSERT INTO users (name, email, role) VALUES
('John Wick', 'baba@yaga.com', 'assassin'),
('Darth Vader', 'nooooo@empire.gov', 'father'),
('Tony Stark', 'ironman@starkindustries.com', 'genius'),
('Sheldon Cooper', 'sheldon@caltech.edu', 'theoretical physicist'),
('Mr. Bean', 'bean@funny.uk', 'mute entertainer'),
('Rick Sanchez', 'rick@multiverse.io', 'mad scientist'),
('Thanos', 'snap@inevitable.com', 'villain'),
('Mario', 'itsme@mushroom.kingdom', 'plumber');

-- Check if the insert was successful
SELECT 'Data inserted' AS status;

-- Query the users table to verify the records
SELECT * FROM users;
