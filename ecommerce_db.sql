-- ecommerce_db.sql
CREATE DATABASE ecommerceDB;
USE ecommerceDB;


-- 1. Create Customers Table
CREATE TABLE customers (
    -> customer_id INT AUTO_INCREMENT PRIMARY KEY,
    -> first_name VARCHAR(80) NOT NULL,
    -> last_name VARCHAR(80) NOT NULL,
    -> email VARCHAR(255) NOT NULL UNIQUE,
    -> phone VARCHAR(30),
    -> password_hash VARCHAR (255) NOT NULL, 
    -> created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -> updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    -> );

-- 2. Create Customers Addresses Table (ONE TO MANY USERS
CREATE TABLE customers_addresses (
    -> address_id INT PRIMARY KEY AUTO_INCREMENT,
    -> customer_id INT NOT NULL,
    -> label VARCHAR(50), -- 'Home'
    -> street VARCHAR(255) NOT NULL,
    -> city VARCHAR(100) NOT NULL,
    -> state VARCHAR(100),
    -> postal_code VARCHAR(30),
    -> country VARCHAR(100) NOT NULL,
    -> is_default BOOLEAN DEFAULT FALSE,
    -> create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -> 
    -> FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
    -> );


    --3. supliers table
    CREATE TABLE suppliers (
    -> supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    -> supplier_name VARCHAR(150) NOT NULL,
    -> contact_name VARCHAR(100),
    -> contact_email VARCHAR(255),
    -> phone VARCHAR(30),
    -> created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    -> );


-- 3. Create Categories Table (Self-referencing for hierarchical categories)
CREATE TABLE categories (
    -> category_id INT PRIMARY KEY AUTO_INCREMENT,
    -> category_name VARCHAR(100) UNIQUE NOT NULL,
    -> description TEXT,
    -> parent_category_id INT NULL,
    -> is_active BOOLEAN DEFAULT TRUE,
    -> created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->     
    -> FOREIGN KEY (parent_category_id) REFERENCES categories(category_id) ON DELETE SET NULL
    -> );



-- 4. Create Products Table
CREATE TABLE products (
    -> product_id INT PRIMARY KEY AUTO_INCREMENT,
    -> product_name VARCHAR(200) NOT NULL,
    -> supplier_id INT,
    -> description TEXT,
    -> category_id INT NOT NULL,
    -> brand VARCHAR(100),
    -> model VARCHAR(100),
    -> price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    -> cost_price DECIMAL(10,2) CHECK (cost_price >= 0),
    -> weight DECIMAL(8,3),
    -> dimensions VARCHAR(100),
    -> color VARCHAR(50),
    -> size VARCHAR(20),
    -> sku VARCHAR(100) UNIQUE NOT NULL,
    -> stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    -> reorder_level INT DEFAULT 10,
    -> is_active BOOLEAN DEFAULT TRUE,
    -> created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -> updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ->     
    -> FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
    -> );

-- 5. Create Product_Categories Table (Many-to-Many relationship between Products and Categories)
CREATE TABLE product_categories (
    -> product_id INT NOT NULL,
    -> category_id INT NOT NULL,
    ->     
    -> PRIMARY KEY (product_id, category_id),
    -> FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    -> FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
    -> );





-- 6. Create Product_Images Table (One-to-Many with Products)
CREATE TABLE product_images (
    -> image_id INT PRIMARY KEY AUTO_INCREMENT,
    -> product_id INT NOT NULL,
    -> url VARCHAR(2048) NOT NULL,
    -> alt_text VARCHAR(255),
    -> sort_index INT DEFAULT 0,
    -> created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->     
    -> FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
    -> );

-- 7. Create Inventory Table (One-to-One with Products)
CREATE TABLE inventory (
    -> product_id INT PRIMARY KEY,
    -> quantity_in_stock INT NOT NULL DEFAULT 0,
    -> reorder_threshold INT NOT NULL DEFAULT 0,
    -> last_restocked DATE,
    ->     
    -> FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
    -> );


-- 8. Create Shopping Cart Table (One-to-Many with Customers and Products)
CREATE TABLE shopping_cart (
    -> cart_id INT PRIMARY KEY AUTO_INCREMENT,
    -> customer_id INT NOT NULL,
    -> product_id INT NOT NULL,
    -> quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    -> added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->     
    -> FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    -> FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    -> UNIQUE KEY unique_customer_product (customer_id, product_id)
    -> );



-- 9. Create Orders Table 
CREATE TABLE orders (
    -> order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    -> customer_id INT NOT NULL,
    -> order_status VARCHAR(50) NOT NULL DEFAULT 'Pending',
    -> placed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -> billing_address_id INT,
    -> shipping_address_id INT,
    -> subtotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    -> tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    -> shipping_cost DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    -> discount_amount DECIMAL(12,2) DEFAULT 0.00,
    -> total_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    -> currency CHAR(3) NOT NULL DEFAULT 'KSH',
    -> notes TEXT,
    -> 
    -> FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE RESTRICT,
    ->  FOREIGN KEY (billing_address_id) REFERENCES customers_addresses(address_id) ON DELETE SET NULL,
    -> FOREIGN KEY (shipping_address_id) REFERENCES customers_addresses(address_id) ON DELETE SET NULL
    -> );


-- 11. Create Order_Items Table (Many-to-Many relationship between Orders and Products)
CREATE TABLE order_items (
    -> order_id BIGINT NOT NULL,
    -> product_id INT NOT NULL,
    -> unit_price DECIMAL(12,2) NOT NULL,
    -> quantity INT NOT NULL CHECK (quantity > 0),
    -> discount DECIMAL(10,2) DEFAULT 0.00,
    -> total_price DECIMAL(12,2) NOT NULL,
    -> created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->     
    -> PRIMARY KEY (order_id, product_id),
    -> FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    -> FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
    -> );



-- 12. Create Payments Table (One-to-One with Orders)
CREATE TABLE payments (
    -> payment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    -> order_id BIGINT NOT NULL,
    -> amount DECIMAL(12,2) NOT NULL,
    -> currency CHAR(3) NOT NULL DEFAULT 'KSH',
    -> method VARCHAR(50) NOT NULL,
    -> status VARCHAR(50) NOT NULL DEFAULT 'Completed',
    -> transaction_id VARCHAR(100) UNIQUE,
    -> paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -> gateway_response TEXT,
    ->     
    -> FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
    -> );




-- 13. Create Shipments Table (One-to-One with Orders)
CREATE TABLE shipments (
    -> shipment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    -> order_id BIGINT NOT NULL,
    -> shipped_at TIMESTAMP NULL,
    -> delivered_at TIMESTAMP NULL,
    -> carrier VARCHAR(100),
    -> tracking_number VARCHAR(255) UNIQUE,
    -> status VARCHAR(50) DEFAULT 'Label Created',
    ->     
    -> FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
    -> );








