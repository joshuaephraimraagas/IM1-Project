-- ============================================================
--  TrendWear Database
--  Generated from ERD & Designer View
-- ============================================================

CREATE DATABASE IF NOT EXISTS trendwear_db;
USE trendwear_db;

-- ============================================================
-- 1. STOREBRANCH
-- ============================================================
CREATE TABLE storebranch (
    StoreBranchID   INT(11)         NOT NULL AUTO_INCREMENT,
    BranchName      VARCHAR(100)    NOT NULL,
    Location        VARCHAR(150)    NOT NULL,
    ManagerName     VARCHAR(100)    NOT NULL,
    PRIMARY KEY (StoreBranchID)
);

-- ============================================================
-- 2. SUPPLIER
-- ============================================================
CREATE TABLE supplier (
    SupplierID      INT(11)         NOT NULL AUTO_INCREMENT,
    SupplierName    VARCHAR(100)    NOT NULL,
    ContactPerson   VARCHAR(100)    NOT NULL,
    Phone           VARCHAR(20)     NOT NULL,
    Email           VARCHAR(100)    NOT NULL,
    PRIMARY KEY (SupplierID)
);

-- ============================================================
-- 3. CATEGORY
-- ============================================================
CREATE TABLE category (
    CategoryID      INT(11)         NOT NULL AUTO_INCREMENT,
    CategoryName    VARCHAR(50)     NOT NULL,
    PRIMARY KEY (CategoryID)
);

-- ============================================================
-- 4. CUSTOMER
-- ============================================================
CREATE TABLE customer (
    CustomerID      INT(11)         NOT NULL AUTO_INCREMENT,
    Name            VARCHAR(100)    NOT NULL,
    Email           VARCHAR(100)    NOT NULL UNIQUE,
    Phone           VARCHAR(20)     NOT NULL,
    Address         VARCHAR(255)    NOT NULL,
    JoinDate        DATE            NOT NULL,
    PRIMARY KEY (CustomerID)
);

-- ============================================================
-- 5. EMPLOYEE
-- ============================================================
CREATE TABLE employee (
    EmployeeID      INT(11)         NOT NULL AUTO_INCREMENT,
    Name            VARCHAR(100)    NOT NULL,
    Position        VARCHAR(50)     NOT NULL,
    Phone           VARCHAR(20)     NOT NULL,
    HireDate        DATE            NOT NULL,
    StoreBranchID   INT(11)         NOT NULL,
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (StoreBranchID) REFERENCES storebranch(StoreBranchID)
);

-- ============================================================
-- 6. PRODUCT
-- ============================================================
CREATE TABLE product (
    ProductID       INT(11)         NOT NULL AUTO_INCREMENT,
    ProductName     VARCHAR(150)    NOT NULL,
    Description     TEXT,
    Price           DECIMAL(10,2)   NOT NULL,
    Size            VARCHAR(20),
    Color           VARCHAR(30),
    StockQuantity   INT(11)         NOT NULL DEFAULT 0,
    SupplierID      INT(11)         NOT NULL,
    PRIMARY KEY (ProductID),
    FOREIGN KEY (SupplierID) REFERENCES supplier(SupplierID)
);

-- ============================================================
-- 7. PRODUCTCATEGORY (junction table: Product <-> Category)
-- ============================================================
CREATE TABLE productcategory (
    ProductID       INT(11)     NOT NULL,
    CategoryID      INT(11)     NOT NULL,
    PRIMARY KEY (ProductID, CategoryID),
    FOREIGN KEY (ProductID)     REFERENCES product(ProductID),
    FOREIGN KEY (CategoryID)    REFERENCES category(CategoryID)
);

-- ============================================================
-- 8. ORDER
-- ============================================================
CREATE TABLE `order` (
    OrderID         INT(11)         NOT NULL AUTO_INCREMENT,
    CustomerID      INT(11)         NOT NULL,
    OrderDate       DATETIME        NOT NULL,
    TotalAmount     DECIMAL(10,2)   NOT NULL,
    Status          ENUM('Pending','Processing','Shipped','Delivered','Cancelled') NOT NULL DEFAULT 'Pending',
    EmployeeID      INT(11)         NOT NULL,
    StoreBranchID   INT(11)         NOT NULL,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (CustomerID)    REFERENCES customer(CustomerID),
    FOREIGN KEY (EmployeeID)    REFERENCES employee(EmployeeID),
    FOREIGN KEY (StoreBranchID) REFERENCES storebranch(StoreBranchID)
);

-- ============================================================
-- 9. ORDERITEM
-- ============================================================
CREATE TABLE orderitem (
    OrderItemID     INT(11)         NOT NULL AUTO_INCREMENT,
    OrderID         INT(11)         NOT NULL,
    ProductID       INT(11)         NOT NULL,
    Quantity        INT(11)         NOT NULL,
    Subtotal        DECIMAL(10,2)   NOT NULL,
    PRIMARY KEY (OrderItemID),
    FOREIGN KEY (OrderID)   REFERENCES `order`(OrderID),
    FOREIGN KEY (ProductID) REFERENCES product(ProductID)
);

-- ============================================================
-- 10. PAYMENT
-- ============================================================
CREATE TABLE payment (
    PaymentID       INT(11)         NOT NULL AUTO_INCREMENT,
    OrderID         INT(11)         NOT NULL,
    PaymentDate     DATETIME        NOT NULL,
    Amount          DECIMAL(10,2)   NOT NULL,
    PaymentMethod   ENUM('Cash','Credit Card','Debit Card','Online','GCash') NOT NULL,
    PRIMARY KEY (PaymentID),
    FOREIGN KEY (OrderID) REFERENCES `order`(OrderID)
);

-- ============================================================
-- 11. REVIEW
-- ============================================================
CREATE TABLE review (
    ReviewID        INT(11)         NOT NULL AUTO_INCREMENT,
    CustomerID      INT(11)         NOT NULL,
    ProductID       INT(11)         NOT NULL,
    Rating          TINYINT(4)      NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment         TEXT,
    ReviewDate      DATETIME        NOT NULL,
    PRIMARY KEY (ReviewID),
    FOREIGN KEY (CustomerID)    REFERENCES customer(CustomerID),
    FOREIGN KEY (ProductID)     REFERENCES product(ProductID)
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

INSERT INTO storebranch (BranchName, Location, ManagerName) VALUES
('TrendWear Cebu Main',  'Cebu City, Cebu',         'Jose Reyes'),
('TrendWear Mandaue',    'Mandaue City, Cebu',       'Anna Lim'),
('TrendWear Lapu-Lapu',  'Lapu-Lapu City, Cebu',    'Mark Santos');

INSERT INTO supplier (SupplierName, ContactPerson, Phone, Email) VALUES
('FabricPro Supplies',  'Ramon Cruz',   '09171234567',  'ramon@fabricpro.com'),
('TextilePlus Co.',     'Linda Go',     '09281234567',  'linda@textileplus.com'),
('StyleSource PH',      'Carlo Tan',    '09391234567',  'carlo@stylesource.com');

INSERT INTO category (CategoryName) VALUES
('Tops'),
('Bottoms'),
('Footwear'),
('Accessories'),
('Outerwear');

INSERT INTO customer (Name, Email, Phone, Address, JoinDate) VALUES
('Joshua Ephraim Raagas',   'joshuaephraimraagas@gmail.com',    '09171111111',  'Cebu City, Cebu',      '2026-05-08'),
('Kenric Muaña',            'kenmuana1@gmail.com',              '09282222222',  'Mandaue City, Cebu',   '2026-05-09'),
('Niño Michael Mahusay',    'ninomichaelmahusay@gmail.com',     '09393333333',  'Lapu-Lapu City, Cebu', '2026-05-10');

INSERT INTO employee (Name, Position, Phone, HireDate, StoreBranchID) VALUES
('Pedro Gomez',     'Sales Associate',  '09174444444',  '2023-06-01',   1),
('Rosa Flores',     'Cashier',          '09285555555',  '2023-07-15',   2),
('Nino Bautista',   'Store Manager',    '09396666666',  '2022-01-10',   3);

INSERT INTO product (ProductName, Description, Price, Size, Color, StockQuantity, SupplierID) VALUES
('Classic White Tee',    'Comfortable everyday white t-shirt',   299.00,     'M',    'White',    50, 1),
('Slim Fit Jeans',       'Modern slim fit denim jeans',          899.00,     '30',   'Blue',     30, 2),
('Running Sneakers',     'Lightweight sport sneakers',           1299.00,    '42',   'Black',    20, 3),
('Floral Summer Dress',  'Light floral print dress',             599.00,     'S',    'Pink',     25, 1),
('Leather Belt',         'Genuine leather belt',                 399.00,     'L',    'Brown',    40, 2);

INSERT INTO productcategory (ProductID, CategoryID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 4);

INSERT INTO `order` (CustomerID, OrderDate, TotalAmount, Status, EmployeeID, StoreBranchID) VALUES
(1, '2024-04-01 10:30:00',  1198.00,    'Delivered',    1,  1),
(2, '2024-04-05 14:00:00',  899.00,     'Shipped',      2,  2),
(3, '2024-04-10 09:15:00',  1898.00,    'Processing',   3,  3);

INSERT INTO orderitem (OrderID, ProductID, Quantity, Subtotal) VALUES
(1, 1,  2,  598.00),
(1, 5,  1,  399.00),
(2, 2,  1,  899.00),
(3, 3,  1,  1299.00),
(3, 1,  2,  598.00);

INSERT INTO payment (OrderID, PaymentDate, Amount, PaymentMethod) VALUES
(1, '2024-04-01 10:35:00',  1198.00,    'GCash'),
(2, '2024-04-05 14:10:00',  899.00,     'Credit Card'),
(3, '2024-04-10 09:20:00',  1898.00,    'Cash');

INSERT INTO review (CustomerID, ProductID, Rating, Comment, ReviewDate) VALUES
(1, 1,  5,  'Great quality t-shirt, very comfortable!',     '2024-04-10 08:00:00'),
(2, 2,  4,  'Nice jeans, fits well.',                       '2024-04-12 10:00:00'),
(3, 3,  5,  'Love the sneakers, very lightweight!',         '2024-04-15 11:00:00');
