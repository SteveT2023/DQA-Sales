-- This SQL file will check for the dataset consistency.

-- Check for consistency for each column.
SELECT 
	COUNT(*) AS Expected_Num_Row,
    (SELECT COUNT(*) FROM raw_sales WHERE ID REGEXP('^[0-9]+$')) AS Result
FROM raw_sales;

SELECT 
	COUNT(*) AS Expected_Num_Row,
    (SELECT COUNT(*) FROM raw_sales WHERE Customer_Name REGEXP('^Customer_[0-9]+$')) AS Result
FROM raw_sales;

SELECT 
	COUNT(*) AS Expected_Num_Row,
    (SELECT COUNT(*) FROM raw_sales WHERE Order_ID REGEXP('^ORD-[0-9]+$')) AS Result
FROM raw_sales;

SELECT 
	COUNT(*) AS Expected_Num_Row,
    (SELECT COUNT(*) FROM raw_sales WHERE Order_Date REGEXP('^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$') OR Order_Date IS NULL) AS Result -- FLAGGED
FROM raw_sales;

SELECT Order_Date FROM raw_sales WHERE Order_Date NOT REGEXP('^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$');

SELECT DISTINCT Product
FROM raw_sales;

SELECT DISTINCT Category -- FLAGGED
FROM raw_sales;

SELECT 
	COUNT(*) AS Expected_Num_Row,
    (SELECT COUNT(*) FROM raw_sales WHERE Quantity REGEXP('^[0-9]+$') OR Quantity IS NULL) AS Result -- FLAGGED
FROM raw_sales;

SELECT Quantity FROM raw_sales WHERE Quantity NOT REGEXP('^[0-9]+$');

SELECT 
	COUNT(*) AS Expected_Num_Row,
    (SELECT COUNT(*) FROM raw_sales WHERE Price REGEXP('^[0-9]+\.[0-9]{1,2}$') OR Price IS NULL) AS Result -- FLAGGED
FROM raw_sales;

SELECT Price FROM raw_sales WHERE Price NOT REGEXP('^[0-9]+\.[0-9]{1,2}$');

SELECT DISTINCT Payment_Method
FROM raw_sales;

SELECT DISTINCT Status
FROM raw_sales;

SELECT 
	COUNT(*) AS Expected_Num_Row,
    (SELECT COUNT(*) FROM raw_sales WHERE Total REGEXP('^[0-9]+\.[0-9]{1,2}$') OR Total IS NULL) AS Result -- FLAGGED
FROM raw_sales;

SELECT Total FROM raw_sales WHERE Total NOT REGEXP('^[0-9]+\.[0-9]{1,2}$');

-- Temporary table to put together all the inconsistent values.
CREATE TEMPORARY TABLE inconsistent_finding
(
	Order_Date VARCHAR(50),
    Category VARCHAR(50),
    Quantity VARCHAR(50),
    Price VARCHAR(50),
    Total VARCHAR(50)
);

-- Insert inconsistent values into the temporary table.
INSERT INTO inconsistent_finding (Order_Date)
SELECT Order_Date 
FROM raw_sales 
WHERE Order_Date NOT REGEXP('^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$');

INSERT INTO inconsistent_finding (Category)
SELECT Category 
FROM raw_sales
WHERE Category = 'nan' OR Category = "";

INSERT INTO inconsistent_finding (Quantity)
SELECT Quantity 
FROM raw_sales 
WHERE Quantity NOT REGEXP('^[0-9]+$');

INSERT INTO inconsistent_finding (Price)
SELECT Price 
FROM raw_sales 
WHERE Price NOT REGEXP('^[0-9]+\.[0-9]{1,2}$');

INSERT INTO inconsistent_finding (Total)
SELECT Total 
FROM raw_sales 
WHERE Total NOT REGEXP('^[0-9]+\.[0-9]{1,2}$');

-- Display result.
SELECT *
FROM inconsistent_finding;

-- Fix the inconsistent values.
UPDATE raw_sales
SET Order_Date = '1/5/2023'
WHERE Order_Date = 'Jan 5 2023';

UPDATE raw_sales
SET Order_Date = NULL
WHERE Order_Date = 'abc';

UPDATE raw_sales
SET Category = NULL
WHERE Category = 'nan' OR Category = "";

UPDATE raw_sales
SET Category = CONCAT(UPPER(LEFT(Category, 1)), LOWER(SUBSTRING(Category, 2)))
WHERE Category = 'electronic';

UPDATE raw_sales
SET Quantity = REPLACE(Quantity, '-', "")
WHERE Quantity REGEXP('^-');

UPDATE raw_sales
SET Quantity = REGEXP_REPLACE(Quantity, '[a-zA-Z]$', "")
WHERE Quantity REGEXP('[a-zA-Z]$');

UPDATE raw_sales
SET Quantity = NULL
WHERE Quantity = '';

UPDATE raw_sales
SET Price = NULL
WHERE Price = 'abd' OR Price = '';

UPDATE raw_sales
SET Price = 400
WHERE Price = 'four hundred';

UPDATE raw_sales
SET Price = REPLACE(Price, '$', '')
WHERE Price REGEXP('\\$');

UPDATE raw_sales
SET Price = REPLACE(Price, '-', '')
WHERE Price REGEXP('^-');

UPDATE raw_sales
SET Price = CAST(Price AS DECIMAL(8, 2));

UPDATE raw_sales
SET Total = NULL
WHERE Total = '';

UPDATE raw_sales
SET Total = REPLACE(Total, '-', '')
WHERE Total REGEXP('^-');

UPDATE raw_sales
SET Total = CAST(Total AS DECIMAL(8, 2));