# Namma Yatri Trip Data Analysis

### Project Overview

Namma Yatri is a Direct-to-Driver open mobility platform, developed by Juspay, powering the next-generation of mobility applications in India. This project involved exploring Namma Yatri trip data using SQL to gain insights into rider behavior and operational patterns. Leveraging basic queries, I analyzed factors like location, payment methods, and time of the day to identify peak usage times, popular routes, and preferred payment options.

This analysis provided valuable insights into potential areas for optimization, improved understanding of ridership trends, and enhanced knowledge of essential SQL data querying techniques.

### Data Sources

add that here

### Tools

- MS SQL
- Tableau

### Exploratory Data Analysis

#### Trip Characteristics:
 - Queries: Employed queries to determine the duration with the highest trip volume, identify most frequent origin-destination pairs, and uncover the most popular payment method for high-value trips.
 - Findings: Revealed valuable insights into rider preferences, peak travel times, and popular routes, potentially informing service optimization efforts.

#### Trip Completion and Cancellations:
 - Queries: Implemented queries to calculate the total number of completed trips and driver-initiated cancellations.
 - Findings: Provided an overview of operational performance and areas for potential improvement in driver support or cancellation prevention strategies.

### Data Analysis
---

#### Some Interesting Queries


**Total searches that got estimate**

```sql

SELECT 
SUM(searches) AS total_searches,
SUM(searches_got_estimate) AS total_estimates,
CONCAT(ROUND(SUM(searches_got_estimate)/SUM(searches) * 100.0,2), '%') AS percentage_of_searches_that_got_estimate
FROM trip_details;
```
**Highest payment was made through which payment method**

```sql
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
```
## Results

This analysis aimed to gain insights into Namma Yatri's ridership behavior, operational efficiency, and identify potential areas for improvement. Here are key findings from the provided queries:

- Trip Completion and Cancellations:

  - Total Completed Trips: 983 trips successfully completed.
  - Driver Cancellations: 137 cancellations initiated by drivers, representing [Percentage]% of accepted quotes.
  - OTP Entered (Trip Started): 983 trips where users started the journey after entering the OTP.
  - End Ride (Completed Trips): 983 trips with confirmed completion, aligning with total completed trips.

- Ridership and Earnings:

  - Total Drivers: 30 unique drivers registered in the system.
  - Total Earnings: Rs. 751,343 in total revenue generated from trips.
  - Earnings per Driver: Drivers with the highest earnings earned Rs. 36,787.
  - Average Fare: The average trip fare was Rs 764.34, providing insight into pricing strategies.

- Trip Characteristics:

  - Average Trip Distance: The average trip covered 14.39 kilometers.
  - Total Distance Travelled: Riders travelled a total of 14,148 kilometers collectively.
  - Most Used Payment Method: Credit Card was the most popular choice for fares.
  - Highest Payment: The highest single trip fare was Rs. 1,500 paid through Credit Card.
  - Most Frequent Trip Duration: 12 AM - 1 AM trips were the most common, offering insights into travel patterns.

- Location-Based Insights:

  - Top Trip Origin-Destination Pairs: Ramanagaram to Shanti Nagar and Gandhi Nagar to Yelahanka were the most frequently travelled routes, highlighting popular areas.
  - Driver Cancellations by Location: Mahadevapura saw the highest number of driver cancellations, warranting further investigation.
  - Highest Fare Routes: Trips between Yeshwantpur and Kanakapura generated the highest total fares, indicating premium routes.

### Reference
---

- [Kaggle](https://www.kaggle.com/datasets/vikramamin/namma-yatri-tableau)

