CREATE DATABASE IF NOT EXISTS Fhamadeli_AI_ecosystem;
USE Fhamadeli_AI_ecosystem;
-- creating tables for roles

CREATE TABLE UserRole(
             role_id INT AUTO_INCREMENT PRIMARY KEY,
            role_name VARCHAR (100) NOT NULL UNIQUE -- EXANPLE; 'Consumer'
);
--  CREATING THE CENTRAL TABLE FOR ALL USERS
CREATE TABLE Users(
user_Id VARCHAR(50) PRIMARY KEY,
username VARCHAR(150) NOT NULL UNIQUE,
email VARCHAR(300) NOT NULL UNIQUE,
password_security  VARCHAR(300) NOT NULL,
phone_number  VARCHAR(15),
role_id   INT NOT NULL,
registration  DATETIME DEFAULT CURRENT_TIMESTAMP,
activity_is_equal_active BOOLEAN DEFAULT TRUE, 
FOREIGN KEY(role_id) REFERENCES UserRole(role_id)
);
-- linking users to their addresses
CREATE TABLE address (
address_id INT AUTO_INCREMENT PRIMARY KEY,
user_id VARCHAR (50),
address VARCHAR(300) NOT NULL,
state VARCHAR(100) NOT NULL,
country VARCHAR (100),
addresstype ENUM('Shipping','Billing','Farm','Office','Warehouse','Park'),
FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
drop table address;
-- CREATE TABLE FOR FARMERS DETAILS ONLY (1:1 with users table)

CREATE TABLE Farmers (
    farmer_id VARCHAR(50) PRIMARY KEY,  -- Same as user_id from Users
    farm_location_name VARCHAR(200) NOT NULL,
    farm_location_address_id INT,    -- Linking to an address for the farm
    farmers_contact_email VARCHAR(200),
    phone_number VARCHAR(15),
    FOREIGN KEY (farmer_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (farm_location_address_id) REFERENCES Address(address_id)
);
 -- CREATE TABLE FOR BUYERS ... This table will store buyers details using 1:1 relationship with users table

CREATE TABLE Buyers (
    buyer_id VARCHAR(50) PRIMARY KEY,  -- Same as user_id from Users
    company_name VARCHAR(150), -- For middlemen
    buyer_type ENUM('middleman', 'consumer') NOT NULL,
    FOREIGN KEY (buyer_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
-- We need to store details of logistic providers , hence the need to create LogisticsProvider table having 1:1 relationships with users table

CREATE TABLE LogisticsProvider (
    provider_id VARCHAR(50) PRIMARY KEY , -- Same as user_id from Users
    company_name VARCHAR(150) NOT NULL,
    service_area TEXT,
    service_rating DECIMAL(2,1) DEFAULT 0.0,
    FOREIGN KEY (provider_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
-- drop table LogisticsProvider
-- Products details are stored in the product table below

CREATE TABLE Product (
    product_id VARCHAR(50) PRIMARY KEY, -- UUID for product identification
    farmer_id VARCHAR(50) NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    product_description TEXT,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    unit_of_measurement VARCHAR(50) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    min_order_quantity INT DEFAULT 1,
    image_url VARCHAR(300),
    date_created DATETIME DEFAULT CURRENT_TIMESTAMP,
    date_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (farmer_id) REFERENCES Farmers(farmer_id) ON DELETE CASCADE
);
-- The following table will store the orders details
   CREATE TABLE Orders (
    order_id VARCHAR(50) PRIMARY KEY, 
    buyer_id VARCHAR(50) NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_status ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
    shipping_address_id INT NOT NULL,
    additional_info TEXT,
    FOREIGN KEY (buyer_id) REFERENCES Buyers(buyer_id) ON DELETE CASCADE,
    FOREIGN KEY (shipping_address_id) REFERENCES Address(address_id)
);
-- More details about an order (Many :Many relationship with complaints_resolution table)
  
CREATE TABLE OrderedItems (
    order_item_id VARCHAR(50) PRIMARY KEY, -- for ordered item identification
    order_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    price_at_order DECIMAL(10, 2) NOT NULL,  -- Price when the order was placed
    current_price  DECIMAL(10, 2) NOT NULL,  -- current price of the ordered item
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE
);
-- All payment transactions can be located in our payments table
CREATE TABLE Payments (
    payment_id VARCHAR(50) PRIMARY KEY, -- UUID for payment identification
    order_id VARCHAR(50) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL, -- e.g., 'credit_card', 'bank_transfer', 'mobile_money'
    transaction_id VARCHAR(255) UNIQUE,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') NOT NULL DEFAULT 'pending',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);
--  This table stores information about delivery tracking

CREATE TABLE Shipments (
    shipment_id VARCHAR(50) PRIMARY KEY, -- UUID for shipment identification
    order_id VARCHAR(50) UNIQUE NOT NULL, -- One order can have one shipment
    provider_id VARCHAR(50) NOT NULL ,
    tracking_number VARCHAR(150) UNIQUE,
    shipment_status ENUM('pending', 'picked_up', 'in_transit', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
    pickup_date DATETIME,
    delivery_date DATETIME,
    estimated_delivery_date DATETIME,
    shipping_cost DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (provider_id) REFERENCES LogisticsProvider(provider_id) ON DELETE CASCADE -- If provider is removed, shipment still exists
);
-- This table  stores details about social networking
CREATE TABLE Posts (
    post_id VARCHAR(50) PRIMARY KEY, -- UUID for post identification
    user_id VARCHAR(50) NOT NULL,
    post_content TEXT NOT NULL,
    image_url VARCHAR(200),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
-- Users comments table
CREATE TABLE Comments (
    comment_id VARCHAR(50) PRIMARY KEY, 
    post_id VARCHAR(50) NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    comment_content TEXT NOT NULL,
    date_created DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
--  This table stores messages between users **subjects to the GDPR data privacy laws 

CREATE TABLE Messages (
    message_id VARCHAR(50) PRIMARY KEY, 
    sender_id VARCHAR(50) NOT NULL,
    receiver_id VARCHAR(50) NOT NULL,
    message_content TEXT NOT NULL,
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
-- This table stores and track service rating by users

CREATE TABLE Ratings (
    rating_id VARCHAR(50) PRIMARY KEY, -- UUID for rating identification
    rater_user_id VARCHAR(50) NOT NULL, -- The user providing the rating
    target_entity_type ENUM('farmer', 'product', 'logistics_provider', 'buyer') NOT NULL,
    target_entity_id VARCHAR(50) NOT NULL, -- ID of the entity being rated (Farmer ID, Product ID, etc.)
    rating_value INT NOT NULL CHECK (rating_value >= 1 AND rating_value <= 5), -- 1 to 5 stars
    comment TEXT,
    date_created DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rater_user_id) REFERENCES Users(user_id) ON DELETE CASCADE
    -- Note: target_entity_id cannot be a direct FK due to polymorphic nature.
    -- Application logic will need to validate this ID based on target_entity_type.
);
-- add details to the role table
INSERT INTO UserRole(role_name) 
VALUES ('farmer'),
        ('Consumer'),
        ('MiddleMan'),
        ('LogisticProvider'),
        ('Fhamadeli_AI_Admin');
       
    ''' SHOW DATABASES;
     USE Fhamadeli_AI_ecosystem;
    SHOW TABLES;
    DESCRIBE Users;    -- checking the most complex table
    SELECT * FROM UserRole;   -- Testing the data inserted into roles;'''

