-- This SQL file will check for the dataset completeness.

-- Procedure to check for nulls, blanks, and whitespaces.
DELIMITER //
	CREATE PROCEDURE completeness_check(IN col_name VARCHAR(50))
		BEGIN
			SET @query = CONCAT(
				'INSERT INTO completeness_result ',
				'SELECT ', 
					'"', col_name, '" AS Column_Name, ',
					'SUM(CASE WHEN ', col_name, ' IS NULL THEN 1 ELSE 0 END) AS Null_Count, ',
					'SUM(CASE WHEN ', col_name, ' = "" THEN 1 ELSE 0 END) AS Blank_Count, ',
					'SUM(CASE WHEN TRIM(', col_name, ') = "" AND ', col_name, ' != "" THEN 1 ELSE 0 END) AS Whitespace_Count ',
                'FROM raw_sales'
            );
            
			PREPARE stmt FROM @query;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        END //
DELIMITER ;

-- Temporary table to display the result.
CREATE TEMPORARY TABLE completeness_result
(
	column_name VARCHAR(50),
    null_count INT,
    blank_count INT,
    Whitespace_count INT
);

-- Call procedure to input data into the temporary table.
CALL completeness_check('ID');
CALL completeness_check('Customer_Name');
CALL completeness_check('Order_ID');
CALL completeness_check('Order_Date');
CALL completeness_check('Product');
CALL completeness_check('Category');
CALL completeness_check('Quantity');
CALL completeness_check('Price');
CALL completeness_check('Payment_Method');
CALL completeness_check('Status');
CALL completeness_check('Total');

-- Display result.
SELECT *
FROM completeness_result;