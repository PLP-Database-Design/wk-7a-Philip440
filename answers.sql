-- Assuming a function like string_split or a similar mechanism exists
-- Replace 'your_database' with the actual name of your database if needed.

CREATE TEMPORARY TABLE NormalizedProductDetail AS
SELECT OrderID, CustomerName, TRIM(value) AS Product
FROM ProductDetail
CROSS APPLY STRING_SPLIT(Products, ',');

-- The NormalizedProductDetail table now conforms to 1NF
SELECT * FROM NormalizedProductDetail;

-- You might then drop the original ProductDetail table and rename
-- the NormalizedProductDetail table if you want to persist the change.
-- DROP TABLE ProductDetail;
-- ALTER TABLE NormalizedProductDetail RENAME TO ProductDetail;


-- Create a new Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT, -- Or your preferred primary key definition
    CustomerName VARCHAR(255) NOT NULL
);

-- Insert distinct customer names into the Customers table
INSERT INTO Customers (CustomerName)
SELECT DISTINCT CustomerName
FROM OrderDetails;

-- Create a new Orders table (without CustomerName)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    Product VARCHAR(255) NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert data into the Orders table, referencing the Customers table
INSERT INTO Orders (OrderID, CustomerID, Product, Quantity)
SELECT od.OrderID, c.CustomerID, od.Product, od.Quantity
FROM OrderDetails od
JOIN Customers c ON od.CustomerName = c.CustomerName;

-- The Orders and Customers tables are now in 2NF
SELECT * FROM Orders;
SELECT * FROM Customers;

-- You might then drop the original OrderDetails table if you want to persist the change.
-- DROP TABLE OrderDetails;
