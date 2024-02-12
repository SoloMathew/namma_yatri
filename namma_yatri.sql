-- total completed trips

SELECT 
COUNT(tripid) 
FROM trip_details
WHERE end_ride = 1;

-- total drivers

SELECT 
COUNT(DISTINCT driverid) 
FROM trips;

-- total earnings

SELECT 
CONCAT('Rs. ', SUM(fare)) AS total_earnings 
FROM trips;

-- earnings per driver

SELECT
driverid,
CONCAT('Rs. ', SUM(fare)) AS total_earnings 
FROM trips
GROUP BY driverid
ORDER BY SUM(fare) DESC;

-- total searches

SELECT 
SUM(searches) AS total_searches 
FROM trip_details;

-- total searches that got estimate

SELECT 
SUM(searches) AS total_searches,
SUM(searches_got_estimate) AS total_estimates,
CONCAT(ROUND(SUM(searches_got_estimate)/SUM(searches) * 100.0,2), '%') AS percentage_of_searches_that_got_estimate
FROM trip_details;

-- total searches that got quote (trip accepted by customer)

SELECT 
SUM(searches) AS total_searches,
SUM(searches_got_quotes) AS total_quotes_accepted,
CONCAT(ROUND(SUM(searches_got_quotes)/SUM(searches) * 100.0,2), '%') AS percentage_of_searches_that_got_quote
FROM trip_details;

-- total driver cancellations

SELECT 
SUM(searches_got_quotes) AS total_quotes_accepted,
SUM(searches_got_quotes) - SUM(driver_not_cancelled) AS total_driver_cancellations,
CONCAT(ROUND((SUM(searches_got_quotes) - SUM(driver_not_cancelled))/SUM(searches_got_quotes) * 100.0,2), '%') AS percentage_of_driver_cancellations
FROM trip_details;

-- total otp entered (trip started)

SELECT 
SUM(otp_entered) AS total_otp_entered
FROM trip_details;

-- total end ride

SELECT 
SUM(end_ride) AS total_trips_competed
FROM trip_details;


-- average trip distance

SELECT
CONCAT(ROUND(AVG(distance),2),' Km') AS average_distance
FROM
trips;

-- average fare for the trip

SELECT
CONCAT('Rs ', ROUND(AVG(fare),2)) AS average_fare
FROM trips;

-- total distance travelled

SELECT
SUM(distance) AS total_distance
FROM trips;

-- most used payment method

SELECT
p.method AS payment_method,
COUNT(p.method) AS usage_count
FROM trips t JOIN payments p
ON t.faremethod = p.id
GROUP BY p.method
ORDER BY usage_count DESC;

-- highest payment was made trough which payment method

SELECT
method
FROM
(
SELECT
tripid,
fare,
method,
RANK() OVER(ORDER BY fare DESC) AS fare_rank
FROM
trips t JOIN payments p
ON t.faremethod = p.id
) AS subquery
WHERE fare_rank = 1;

-- which two locations had the most number of trips

SELECT
TOP 2
t.loc_to,
l.assembly,
COUNT(t.loc_to) AS number_of_trips
FROM
trips t JOIN loc l
ON t.loc_to = l.id
GROUP BY t.loc_to, l.assembly
ORDER BY 3 DESC;

-- which duration had the most number of trips

SELECT 
TOP 1
d.duration,
COUNT(t.duration) number_of_trips
FROM trips t JOIN duration d
ON t.duration = d.id
GROUP BY d.duration
ORDER BY 2 DESC;

-- which driver, customer pair had the most number of trips

SELECT
driverid, 
custid, 
number_of_trips
FROM
(
SELECT 
DENSE_RANK() OVER(ORDER BY COUNT(tripid) DESC) AS ranks,
driverid, 
custid, 
COUNT(tripid) number_of_trips
FROM trips
GROUP BY driverid, custid
) subquery
WHERE ranks = 1;

-- which area got the highest trips in each duration

SELECT
duration, 
loc_from, 
number_of_trips
FROM
(
SELECT 
DENSE_RANK() OVER(PARTITION BY duration ORDER BY COUNT(loc_from) DESC) AS ranks,
duration, 
loc_from, 
COUNT(loc_from) AS number_of_trips
FROM trips
GROUP BY duration, loc_from
) subquery
WHERE ranks = 1;

-- -- in between which locations did we get the highest fares

WITH loc_fare_cte AS
(
SELECT 
TOP 10
t.loc_from,
t.loc_to,
COUNT(t.tripid) AS total_trips,
SUM(fare) AS total_fare
FROM trips t
GROUP BY t.loc_from, t.loc_to
ORDER BY 4 DESC
)

SELECT
lf.Assembly AS assembly_from,
lt.Assembly AS assembly_to,
c.total_trips,
c.total_fare
FROM
loc_fare_cte c JOIN loc lf
ON c.loc_from = lf.id
JOIN loc lt
ON c.loc_to = lt.id
ORDER BY 4 DESC;

-- in between which locations did we get the highest trips


WITH loc_trip_cte AS
(
SELECT 
TOP 10
t.loc_from,
t.loc_to,
COUNT(t.tripid) AS total_trips
FROM trips t
GROUP BY t.loc_from, t.loc_to
ORDER BY 3 DESC,1 DESC,2 DESC
)

SELECT
lf.Assembly AS assembly_from,
lt.Assembly AS assembly_to,
c.total_trips
FROM
loc_trip_cte c JOIN loc lf
ON c.loc_from = lf.id
JOIN loc lt
ON c.loc_to = lt.id
ORDER BY 3 DESC;

-- in which location did we get the highest driver cancellations

SELECT 
TOP 1
l.Assembly,
SUM(searches_got_quotes) - SUM(driver_not_cancelled) AS total_driver_cancellations
FROM trip_details t JOIN loc l
ON t.loc_from = l.id
WHERE t.searches_got_quotes = 1 AND t.driver_not_cancelled = 0
GROUP BY l.Assembly
ORDER BY 2 DESC;
