create database ZD;
use ZD;
SHOW COLUMNS FROM Restaurants;
select * from Restaurants;
#2=======================================================#
CREATE TABLE CalendarTable AS
SELECT 
    -- Convert 'Year Month' into a proper date format (YYYY-MM-01)
    STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d') AS Datekey,

    -- Extract Year and Month Number
    SUBSTRING(`Year Month`, 1, 4) AS Year,
    MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) AS Monthno,
    
    -- Get Full Month Name
    DATE_FORMAT(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d'), '%M') AS Monthfullname,
		
    -- Get Calendar Quarter
    CONCAT('Q', QUARTER(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d'))) AS Quarter,
    
    -- Format Year-Month as YYYY-MMM
    `Year Month` AS YearMonth,
    
    -- Weekday Number (Monday = 1, Sunday = 7)
    WEEKDAY(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) + 1 AS Weekdayno,
    
    -- Weekday Name
    DATE_FORMAT(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d'), '%W') AS Weekdayname,

    -- Financial Month (April = FM1, ..., March = FM12)
    CASE 
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) = 4 THEN 'FM1'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) = 5 THEN 'FM2'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) = 6 THEN 'FM3'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) = 7 THEN 'FM4'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) = 8 THEN 'FM5'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) = 9 THEN 'FM6'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) = 10 THEN 'FM7'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) = 11 THEN 'FM8'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) = 12 THEN 'FM9'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) = 1 THEN 'FM10'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) = 2 THEN 'FM11'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) = 3 THEN 'FM12'
    END AS FinancialMonth,

    -- Financial Quarter based on Financial Month
    CASE 
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) IN (4, 5, 6) THEN 'FQ1'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) IN (7, 8, 9) THEN 'FQ2'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) IN (10, 11, 12) THEN 'FQ3'
        WHEN MONTH(STR_TO_DATE(CONCAT(SUBSTRING(`Year Month`, 1, 4), '-', SUBSTRING(`Year Month`, 6, 3), '-01'), '%Y-%b-%d')) IN (1, 2, 3) THEN 'FQ4'
    END AS FinancialQuarter

FROM Restaurants;
select * from CalendarTable ;

#3=======================================================#
SELECT City, CountryCode, COUNT(RestaurantID) AS RestaurantCount
FROM Restaurants
GROUP BY City, CountryCode
ORDER BY CountryCode, RestaurantCount DESC;

#4=========================================================#
SELECT Year, Quarter, Month, COUNT(RestaurantID) AS RestaurantCount
FROM Restaurants
GROUP BY Year, Quarter, Month
ORDER BY Year, Quarter, Month;

#5==========================================================#
SELECT 
    ROUND(Rating, 1) AS Rating, 
    COUNT(*) AS Restaurant_Count
FROM Restaurants
WHERE Rating IS NOT NULL
GROUP BY ROUND(Rating, 1)
ORDER BY Rating DESC;

#6===========================================================#
SELECT 
    CASE 
        WHEN Average_Cost_for_two BETWEEN 0 AND 250 THEN '0 - 250'
        WHEN Average_Cost_for_two BETWEEN 251 AND 500 THEN '251 - 500'
        WHEN Average_Cost_for_two BETWEEN 501 AND 1000 THEN '501 - 1000'
        WHEN Average_Cost_for_two BETWEEN 1001 AND 2500 THEN '1001 - 2500'
        WHEN Average_Cost_for_two BETWEEN 2501 AND 5000 THEN '2501 - 5000'
        ELSE '5001 and above'
    END AS Price_Bucket,
    COUNT(RestaurantID) AS RestaurantCount
FROM Restaurants
GROUP BY Price_Bucket
ORDER BY RestaurantCount DESC;

#7====================================================#
SELECT 
    `Has_Table_booking`, 
    COUNT(RestaurantID) AS RestaurantCount,
    (COUNT(RestaurantID) * 100.0 / (SELECT COUNT(*) FROM Restaurants)) AS Percentage
FROM Restaurants
GROUP BY `Has_Table_booking`;

#8=====================================================#
SELECT 
    `Has_Online_delivery` AS OnlineDelivery,
    COUNT(RestaurantID) AS RestaurantCount,
    ROUND((COUNT(RestaurantID) * 100.0 / (SELECT COUNT(*) FROM Restaurants)), 2) AS Percentage
FROM Restaurants
GROUP BY `Has_Online_delivery`;


select * from meeting;

Alter table meeting change column `ï»¿Account Exe ID` Account_Exe_ID int;

SELECT 
    YEAR(STR_TO_DATE(meeting_date, '%d-%m-%Y')) AS meeting_year,
    COUNT(*) AS meeting_count
FROM meeting
GROUP BY meeting_year
ORDER BY meeting_year;


select * from invoice ;
Alter Table invoice change column `ï»¿invoice_number` invoice_number int;
Alter Table invoice change column `Client Name` Client_Name varchar(50);
SELECT 
    invoice_number,
    invoice_date,
    branch_name,
    Client_Name,
    amount,
    income_due_date,
    CASE 
        WHEN income_due_date IS NULL THEN 'Paid'
        ELSE 'Unpaid'
    END AS payment_status
FROM invoice;
select * from opportunity;
Alter table opportunity change Column `ï»¿opportunity_name`opportunity_name varchar(100);
Alter table opportunity change Column `Account Executive` Account_Executive varchar(50);
SELECT opportunity_name, opportunity_id, revenue_amount,Account_Executive, branch, closing_date
FROM Opportunity
ORDER BY revenue_amount DESC
LIMIT 4;



