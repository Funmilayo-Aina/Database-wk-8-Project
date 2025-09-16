# Database Project
Database Management System for Farmers Ecosystem (MVP-Fish Farming)

## Use Case: Fish Farmers Ecosystem - Logistics, Payment, and Social Networking Management

This repository contains the database schema and implementation for a Farmers Ecosystem management system. The system aims to facilitate logistics, payment processing, and social networking for fish farmers, middlemen, and consumers.

## Project Objective

To design and implement a comprehensive relational database using MySQL for a real-world use case focused on the fish farming supply chain. The Minimum Viable Product (MVP) specifically targets logistics, payment, and social networking management for fish farmers and their stakeholders.

## Database Schema Design

The database is designed with a relational model to ensure data integrity, minimize redundancy, and support the various functionalities of the ecosystem.

### Core Entities and Relationships:

*   **Users**: A central table to manage all system users (Farmers, Middlemen, Consumers, Logistics Providers).
*   **UserRole**: Defines distinct roles within the system. (One-to-Many with Users)
*   **Address**: Stores geographical addresses linked to users. (One-to-Many with Users)
*   **Farmers**: Specific profiles for fish farmers. (One-to-One with Users)
*   **Buyers**: Profiles for individuals or businesses purchasing fish (can be Middlemen or Consumers). (One-to-One with Users)
*   **LogisticsProviders**: Profiles for entities responsible for delivery. (One-to-One with Users)
*   **Product**: Fish products available for sale by farmers. (One-to-Many from Farmers)
*   **Orders**: Records purchase transactions initiated by buyers.
*   **OrderItems**: Details the specific products and quantities within each order. (Many-to-Many between Orders and Products)
*   **Payment**: Manages all payment transactions related to orders. (One-to-Many from Orders)
*   **Shipments**: Tracks the logistical delivery process of orders. (One-to-One with Orders, One-to-Many from LogisticsProviders)
*   **Posts**: Enables social media-like communication. (One-to-Many from Users)
*   **Comments**: Allows users to comment on posts. (One-to-Many from Users, One-to-Many from Posts)
*   **Messages**: Facilitates direct messaging between users. (Many-to-Many between Users)
*   **Ratings**: Allows users to provide feedback and ratings on farmers, products, or logistics providers.

### Relationships Implemented:

*   **One-to-One**:
    *   `Users` to `Farmers`
    *   `Users` to `Buyers`
    *   `Users` to `LogisticsProviders`
    *   `Orders` to `Shipments` (one order has one shipment)
*   **One-to-Many**:
    *   `UserRoles` to `Users`
    *   `Users` to `Addresses`
    *   `Farmers` to `Products`
    *   `Users` to `Orders` (via `Buyers` table)
    *   `LogisticsProviders` to `Shipments`
    *   `Orders` to `Payments`
    *   `Orders` to `OrderItems`
    *   `Products` to `OrderItems`
    *   `Users` to `Posts`
    *   `Posts` to `Comments`
    *   `Users` to `Comments`
    *   `Users` to `Messages` (as sender/receiver)
*   **Many-to-Many**:
    *   `Buyers` and `Products` (resolved via `Orders` and `OrderItems` tables)
    *   `Users` and `Users` (for direct messages, resolved via `Messages` table with `sender_id` and `receiver_id`)
    *   `Users` and `Farmers`/`Products`/`LogisticsProviders` (for ratings, resolved via `Ratings` table)

## Deliverables

### `database_schema.sql`

This file contains the complete MySQL script to set up the database:
1.  `CREATE DATABASE` statement to create `fish_farmers_ecosystem`.
2.  `USE` statement to select the database.
3.  `CREATE TABLE` statements for all entities, including:
    *   Appropriate data types for each column.
    *   `PRIMARY KEY` constraints for unique identification of records.
    *   `FOREIGN KEY` constraints to establish relationships and ensure referential integrity.
    *   `NOT NULL` constraints for essential data fields.
    *   `UNIQUE` constraints for columns requiring unique values (e.g., username, email, tracking numbers).
4.  Initial `INSERT` statements for `UserRoles`.

## How to Set Up the Database

1.  **Install MySQL:** Ensure you have MySQL Server installed and running on your system.
2.  **Access MySQL:** Use a MySQL client (e.g., MySQL Workbench, `mysql` command-line client, DBeaver) to connect to your MySQL server.
3.  **Execute the SQL Script:**
    *   Open the `database_schema.sql` file.
    *   Copy the entire content of the file.
    *   Paste and execute the queries in your MySQL client.

    Alternatively, from the command line:
    ```bash
    mysql -u your_username -p < database_schema.sql
    ```
    (You will be prompted to enter your MySQL password.)

4. ** Sample DB text code, uncomment and use as required**
   --  SHOW DATABASES;
    -- USE Fhamadeli_AI_ecosystem;
    -- SHOW TABLES;
    -- DESCRIBE Users; -- Or any other table to see its structure
    -- SELECT * FROM UserRoles; -- To see initial role data

''' This DataBase is set up in preparation for FAST API CRUD APP''
