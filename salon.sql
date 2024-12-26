-- Drop tables if they already exist (useful for reinitializing the database)
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS services;

-- Create the `services` table
CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

-- Create the `customers` table
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  phone VARCHAR(20) UNIQUE NOT NULL
);

-- Create the `appointments` table
CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id),
  service_id INT REFERENCES services(service_id),
  time VARCHAR(20) NOT NULL
);

-- Insert sample data into the `services` table
INSERT INTO services (name) VALUES
  ('Cut'),
  ('Color'),
  ('Perm');
