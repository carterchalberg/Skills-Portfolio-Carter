-- Carter Chalberg. No Excel files needed for this as all data comes from the book. --

-- Module 3 --

CREATE TABLE SUMMER_SCHOOL_RENTALS (
    PROPERTY_ID     NUMERIC,       
    OFFICE_NUMBER   NUMERIC,       
    ADDRESS         VARCHAR(100),
    SQR_FT          INT,
    BDRMS           INT,
    FLOORS          INT,
    WEEKLY_RENT     DECIMAL(8,2),  
    OWNER_NUM       CHAR(5)
);

INSERT INTO SUMMER_SCHOOL_RENTALS
    (PROPERTY_ID, OFFICE_NUMBER, ADDRESS, SQR_FT, BDRMS, FLOORS, WEEKLY_RENT, OWNER_NUM)
VALUES
    (13, 1, '5867 Goodwin Ave', 1650, 2, 1, 400, 'CO103');

DROP TABLE SUMMER_SCHOOL_RENTALS;

DESCRIBE Office;
DESCRIBE Owner;
DESCRIBE Property;
DESCRIBE Service_Category;
DESCRIBE Service_Request;
DESCRIBE Residents;

SELECT * FROM office;
SELECT * FROM owner;
SELECT * FROM property;
SELECT * FROM service_category;
SELECT * FROM service_request;
SELECT * FROM residents;

-- Module 4 --
SELECT owner_num, last_name, first_name
FROM Owner;

SELECT *
FROM Property;

SELECT last_name, first_name
FROM Owner
WHERE city = 'Seattle';

SELECT last_name, first_name
FROM Owner
WHERE city != 'Seattle';

SELECT property_id, office_num
FROM Property
WHERE sqr_ft <= 1400;

SELECT office_num, address
FROM Property
WHERE bdrms = 3;

SELECT Property.property_id
FROM Property
JOIN Office ON Property.office_num = Office.office_num
WHERE Property.bdrms = 2
	AND Office.office_name = 'StayWell Georgetown';

SELECT property_id
FROM Property
WHERE monthly_rent BETWEEN 1350 AND 1750;

SELECT Property.property_id
FROM Property
JOIN Office ON Property.office_num = Office.office_num
WHERE Office.office_name = 'StayWell- Columbia City'
  AND Property.monthly_rent < 1500;
  
SELECT property_id, category_number, est_hours, (est_hours * 35) AS ESTIMATED_COST
FROM Service_Request;

SELECT owner_num, last_name
FROM Owner
WHERE state IN ('NV', 'OR', 'ID');

SELECT office_num, property_id, sqr_ft, monthly_rent
FROM Property
ORDER BY sqr_ft DESC, monthly_rent DESC;

SELECT office_num, COUNT(*) AS three_bedroom
FROM Property
WHERE bdrms = 3
GROUP BY office_num;

SELECT SUM(monthly_rent) AS total_rent
FROM Property;

-- Module 5 --

SELECT Property.office_num, Property.address, Property.monthly_rent, Owner.owner_num, Owner.first_name, Owner.last_name
FROM property 
JOIN OWNER ON Property.owner_num = Owner.owner_num;

SELECT property_id, description, status
FROM Service_Request
WHERE status IS NOT NULL;

SELECT Property.property_id, Property.office_num, Property.address, Service_Request.est_hours, Service_Request.spent_hours, Owner.owner_num, Owner.last_name
FROM Service_Request
JOIN Service_Category on Service_Request.category_number = Service_Category.category_num
JOIN Property on Service_Request.property_id = Property.property_id
JOIN Owner on Property.owner_num = Owner.owner_num
WHERE Service_Category.category_description = 'Furniture';

SELECT DISTINCT Owner.first_name, Owner.last_name
FROM Owner
JOIN Property on Owner.owner_num = Property.owner_num
WHERE Property.bdrms = 2;

SELECT first_name, last_name
FROM Owner
WHERE Exists (
	SELECT 1
    FROM Property
    WHERE Property.owner_num = Owner.owner_num
		AND Property.bdrms = 2
);

-- Question 6 I'm having trouble with, couldn't figure this one out --

SELECT Property.sqr_ft, Owner.owner_num, Owner.first_name, Owner.last_name
FROM Property
JOIN Owner on Property.owner_num = Owner.owner_num
JOIN Office on Property.office_num = Office.office_num
WHERE Office.office_name = 'StayWell- Columbia City';

SELECT Property.sqr_ft, Owner.owner_num, Owner.first_name, Owner.last_name
FROM Property
JOIN Owner on Property.owner_num = Owner.owner_num
JOIN Office on Property.office_num = Office.office_num
WHERE Office.office_name = 'StayWell- Columbia City'
	AND Property.bdrms = 3;

SELECT Property.office_num, Property.address, Property.monthly_rent
FROM Property
JOIN Owner on Property.owner_num = Owner.owner_num
WHERE Owner.state = 'WA'
	OR Property.bdrms = 2;

SELECT Property.office_num, Property.address, Property.monthly_rent
FROM Property
JOIN Owner on Property.owner_num = Owner.owner_num
WHERE Owner.state = 'WA'
	AND Property.bdrms = 2;
    
SELECT Property.office_num, Property.address, Property.monthly_rent
FROM Property
JOIN Owner on Property.owner_num = Owner.owner_num
WHERE Owner.state = 'WA'
	AND Property.bdrms != 2;

SELECT service_id, property_id
FROM Service_Request
WHERE est_hours > ANY(
	SELECT est_hours
    FROM Service_Request
    WHERE category_number = 5
);

SELECT service_id, property_id
FROM Service_Request
WHERE est_hours > ALL(
	SELECT est_hours
    FROM Service_Request
    WHERE category_number = 5
);

SELECT Property.address, Property.sqr_ft, Owner.owner_num, Service_Request.service_id, Service_Request.est_hours, Service_Request.spent_hours
FROM Service_Request
JOIN Property on Service_Request.property_id = Property.property_id
JOIN Owner on Property.owner_num = Owner.owner_num
WHERE Service_Request.category_number = 4;

SELECT Property.address, Property.sqr_ft, Owner.owner_num, Service_Request.service_id, Service_Request.est_hours, Service_Request.spent_hours
FROM Property
JOIN Owner On Property.owner_num = Owner.owner_num
LEFT JOIN Service_Request On Property.property_id = Service_Request.property_id AND Service_Request.category_number = 4;

SELECT Property.address, Property.sqr_ft, Owner.owner_num, Service_Request.service_id, Service_Request.est_hours, Service_Request.spent_hours
FROM Property
JOIN Owner On Property.owner_num = Owner.owner_num
LEFT JOIN Service_Request On Property.property_id = Service_Request.property_id
WHERE Service_Request.category_number = 4 OR Service_Request.category_number IS NULL;

-- Module 6 --

CREATE TABLE large_property (

    office_num      DECIMAL(2,0),    
    address         CHAR(25),        
    bdrms           DECIMAL(2,0),
    floors          DECIMAL(2,0),
    monthly_rent    DECIMAL(6,2),
    owner_num       CHAR(5),
    PRIMARY KEY (office_num, address)
);

INSERT INTO LARGE_PROPERTY (office_num, address, bdrms, floors, monthly_rent, owner_num)
SELECT office_num, address, bdrms, floors, monthly_rent, owner_num
FROM Property
WHERE sqr_ft > 1500;
-- this one said bathrooms but bathrooms weren't anywhere in the original table so I did floors instead --

UPDATE LARGE_PROPERTY
SET monthly_rent = monthly_rent + 150;

UPDATE LARGE_PROPERTY
SET monthly_rent = monthly_rent * (1 - 0.01)
WHERE monthly_rent > 1750;

INSERT INTO LARGE_PROPERTY (office_num,address,bdrms,floors,monthly_rent,owner_num)
VALUES (1,'2643 Lugsi Dr',3,2,775,'MA111');

DELETE FROM LARGE_PROPERTY
WHERE owner_num = 'BI109';

UPDATE LARGE_PROPERTY
SET bdrms = NULL
WHERE address = '105 North Illinois Rd.';

ALTER TABLE LARGE_PROPERTY
ADD OCCUPIED CHAR(1);

UPDATE LARGE_PROPERTY
SET OCCUPIED = 'Y';

UPDATE LARGE_PROPERTY
SET OCCUPIED = 'N'
WHERE office_num = 9;

ALTER TABLE LARGE_PROPERTY
MODIFY monthly_rent DECIMAL(6,2) NOT NULL;

DROP TABLE LARGE_PROPERTY;
-----------------------------------
-- Critical Thinking Questions --
-- Module 3: Yes, one alternate to the use of CHAR in the Service Request would be VARCHAR because instead of using say 15 slots for a 4 letter word you could use varchar and save some space --
-- Module 4: --
SELECT OWNER_NUM, LAST_NAME
FROM OWNER
WHERE STATE = 'NV'
   OR STATE = 'OR'
   OR STATE = 'ID';

-- WHERE DESCRIPTION LIKE '%heating%' --


-- Module 5:
CREATE TABLE LARGE_PROPERTY (
    OFFICE_NUM     INTEGER       NOT NULL,
    ADDRESS        CHAR(25)      NOT NULL,
    BDRMS          INTEGER,
    FLOORS         INTEGER,
    MONTHLY_RENT   DECIMAL(6,2),
    OWNER_NUM      CHAR(5),
    PRIMARY KEY (OFFICE_NUM, ADDRESS)
);
-- to find the integer data type I went to the oracle database and then I went to the basic elements of SQL and then I went to data types and scrolled until I found the integer --


