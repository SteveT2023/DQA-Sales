-- This SQL file will check for the dataset uniqueness.

-- Searching for duplicates in the following columns: ID & Order_ID
SELECT ID AS Value, COUNT(*) AS Duplicate_Count
FROM raw_sales
GROUP BY ID
HAVING COUNT(*) >= 2

UNION ALL

SELECT Order_ID, COUNT(*)
FROM raw_sales
GROUP BY Order_ID
HAVING COUNT(*) >= 2;

-- Remove the duplicates.
SELECT ID, Quantity, Price, Total, (Quantity * Price) AS Real_Total
FROM raw_sales
WHERE ID = 142;

DELETE FROM raw_sales
WHERE ID = 142 AND Total = 2258.41;

ALTER TABLE raw_sales
ADD COLUMN Delete_ID INT AUTO_INCREMENT PRIMARY KEY FIRST;

DELETE FROM raw_sales
WHERE ID = 146 AND Delete_ID = 102;

ALTER TABLE raw_sales
DROP COLUMN Delete_ID;

SELECT ID, Quantity, Price, Total, (Quantity * Price) AS Real_Total
FROM raw_sales
WHERE ID = 175;

DELETE FROM raw_sales
WHERE ID = 175 AND Total = 77.952;