-- =========================
-- Create Database
-- =========================
CREATE DATABASE ecommerce_db;
USE ecommerce_db;



-- =========================
-- Customer
-- =========================
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- Category
-- =========================
CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- =========================
-- Product
-- =========================
CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    description VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- Product ↔ Category (M:N)
-- =========================
CREATE TABLE Product_Category (
    product_id INT,
    category_id INT,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- =========================
-- Order
-- =========================
CREATE TABLE `Order` (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- =========================
-- Order ↔ Product (M:N)
-- =========================
CREATE TABLE Order_Item (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- =========================
-- Payment
-- =========================
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id)
);

-- =========================
-- Shipment
-- =========================
CREATE TABLE Shipment (
    shipment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    shipment_date DATETIME,
    delivery_date DATETIME,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id)
);

-- =========================
-- Supplier
-- =========================
CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    phone VARCHAR(15)
);

-- =========================
-- Product ↔ Supplier (M:N)
-- =========================
CREATE TABLE Product_Supplier (
    product_id INT,
    supplier_id INT,
    PRIMARY KEY (product_id, supplier_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
);

-- =========================
-- Inventory
-- =========================
CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    quantity_available INT NOT NULL CHECK (quantity_available >= 0),
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- =========================
-- Review (Customer ↔ Product)
-- =========================
CREATE TABLE Review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text VARCHAR(255),
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);
-- =========================
-- Customers
-- =========================
INSERT INTO Customer (first_name, last_name, email, phone) VALUES
('Amit', 'Sharma', 'amit@gmail.com', '9876543210'),
('Priya', 'Singh', 'priya@gmail.com', '9123456789'),
('Rahul', 'Verma', 'rahul@gmail.com', '9988776655'),
('Neha', 'Patel', 'neha@gmail.com', '9090909090'),
('Arjun', 'Mehta', 'arjun@gmail.com', '9000011111');

-- =========================
-- Categories
-- =========================
INSERT INTO Category (category_name, description) VALUES
('Electronics', 'Electronic products'),
('Clothing', 'Fashion and apparel'),
('Home', 'Home appliances');

-- =========================
-- Products
-- =========================
INSERT INTO Product (product_name, price, description) VALUES
('Laptop', 75000, 'Gaming laptop'),
('Smartphone', 35000, 'Android phone'),
('T-Shirt', 999, 'Cotton T-shirt'),
('Washing Machine', 42000, 'Front load washer'),
('Headphones', 2999, 'Wireless headphones');

-- =========================
-- Product_Category
-- =========================
INSERT INTO Product_Category VALUES
(1,1),(2,1),(5,1),
(3,2),
(4,3);

-- =========================
-- Orders
-- =========================
INSERT INTO `Order` (customer_id, status, total_amount) VALUES
(1, 'Completed', 110000),
(2, 'Pending', 999),
(3, 'Completed', 42000),
(4, 'Cancelled', 2999),
(5, 'Completed', 35000);

-- =========================
-- Order_Item
-- =========================
INSERT INTO Order_Item VALUES
(1,1,1,75000),
(1,2,1,35000),
(2,3,1,999),
(3,4,1,42000),
(4,5,1,2999),
(5,2,1,35000);

-- =========================
-- Payment
-- =========================
INSERT INTO Payment (order_id, payment_method, amount, status) VALUES
(1,'Card',110000,'Success'),
(2,'UPI',999,'Pending'),
(3,'Net Banking',42000,'Success'),
(5,'Card',35000,'Success');

-- =========================
-- Shipment
-- =========================
INSERT INTO Shipment (order_id, shipment_date, delivery_date, status) VALUES
(1,NOW(),NOW(),'Delivered'),
(3,NOW(),NULL,'In Transit'),
(5,NOW(),NULL,'Shipped');

-- =========================
-- Supplier
-- =========================
INSERT INTO Supplier (supplier_name, contact_email, phone) VALUES
('TechSupplier Ltd','tech@supplier.com','8888888888'),
('FashionHub','fashion@supplier.com','7777777777');

-- =========================
-- Product_Supplier
-- =========================
INSERT INTO Product_Supplier VALUES
(1,1),(2,1),(5,1),
(3,2);

-- =========================
-- Inventory
-- =========================
INSERT INTO Inventory (product_id, quantity_available) VALUES
(1,20),(2,35),(3,100),(4,10),(5,50);

-- =========================
-- Review
-- =========================
INSERT INTO Review (customer_id, product_id, rating, review_text) VALUES
(1,1,5,'Excellent laptop'),
(2,3,4,'Good quality'),
(3,4,5,'Works perfectly'),
(4,5,3,'Average'),
(5,2,4,'Very good phone');


SELECT * FROM Product;

SELECT * FROM `Order`;

SELECT * FROM `Order`;




-- View 1: Total Sales per Customer
CREATE VIEW Total_Sales_Per_Customer AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    SUM(o.total_amount) AS total_spent
FROM Customer c
JOIN `Order` o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

SELECT * FROM Total_Sales_Per_Customer;

-- View 2: Monthly Sales Trend
CREATE VIEW Monthly_Sales_Trend AS
SELECT 
    DATE_FORMAT(order_date,'%Y-%m') AS month,
    SUM(total_amount) AS total_sales
FROM `Order`
GROUP BY month;
SELECT 
    c.first_name,
    SUM(o.total_amount) AS total_spent
FROM Customer c
JOIN `Order` o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING total_spent > 30000;
SELECT 
    cat.category_name,
    SUM(oi.quantity * oi.price) AS revenue
FROM Order_Item oi
JOIN Product p ON oi.product_id = p.product_id
JOIN Product_Category pc ON p.product_id = pc.product_id
JOIN Category cat ON pc.category_id = cat.category_id
GROUP BY cat.category_name;
SELECT 
    order_id,
    total_amount,
    CASE 
        WHEN total_amount > 50000 THEN 'High Value'
        WHEN total_amount BETWEEN 10000 AND 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_type
FROM `Order`;

SELECT * FROM Monthly_Sales_Trend;


SELECT first_name, last_name
FROM Customer
WHERE customer_id IN (
    SELECT customer_id
    FROM `Order`
    WHERE total_amount > (SELECT AVG(total_amount) FROM `Order`)
);
SELECT 
    c.first_name,
    SUM(o.total_amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spending_rank
FROM Customer c
JOIN `Order` o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;



DELIMITER //
CREATE PROCEDURE GetCustomerOrders(IN cust_id INT)
BEGIN
    SELECT *
    FROM `Order`
    WHERE customer_id = cust_id;
END //
DELIMITER ;


CALL GetCustomerOrders(1);
DELIMITER //
CREATE FUNCTION CalculateDiscount(amount DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN amount * 0.10;
END //
DELIMITER ;





CREATE INDEX idx_order_customer ON `Order`(customer_id);

SHOW INDEX FROM `Order`;



