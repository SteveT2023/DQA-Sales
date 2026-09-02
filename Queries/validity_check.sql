-- This SQL file will check for the dataset validity.

-- Sort the order of the ID column from least to greatest.
ALTER TABLE raw_sales
ORDER BY ID ASC;

-- Fix Order_Date Format
UPDATE raw_sales
SET Order_Date = STR_TO_DATE(Order_Date, '%m/%d/%Y');

-- Change the column's datatype to the correct one.
ALTER TABLE raw_sales
MODIFY COLUMN ID INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE raw_sales
MODIFY COLUMN Customer_Name VARCHAR(50);

ALTER TABLE raw_sales
MODIFY COLUMN Order_ID VARCHAR(50);

ALTER TABLE raw_sales
MODIFY COLUMN Order_Date DATE;

ALTER TABLE raw_sales
MODIFY COLUMN Product VARCHAR(50);

ALTER TABLE raw_sales
MODIFY COLUMN Category VARCHAR(50);

ALTER TABLE raw_sales
MODIFY COLUMN Quantity INT;

ALTER TABLE raw_sales
MODIFY COLUMN Price DECIMAL(8, 2);

ALTER TABLE raw_sales
MODIFY COLUMN Payment_Method VARCHAR(50);

ALTER TABLE raw_sales
MODIFY COLUMN Status VARCHAR(50);

ALTER TABLE raw_sales
MODIFY COLUMN Total DECIMAL(8, 2);