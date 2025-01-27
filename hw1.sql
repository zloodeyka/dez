SELECT
    COUNT(*) FILTER (WHERE trip_distance <= 1) AS up_to_1_mile,
    COUNT(*) FILTER (WHERE trip_distance > 1 AND trip_distance <= 3) AS between_1_and_3_miles,
    COUNT(*) FILTER (WHERE trip_distance > 3 AND trip_distance <= 7) AS between_3_and_7_miles,
    COUNT(*) FILTER (WHERE trip_distance > 7 AND trip_distance <= 10) AS between_7_and_10_miles,
    COUNT(*) FILTER (WHERE trip_distance > 10) AS over_10_miles
FROM
    public.yellow_taxi_trips
WHERE
    lpep_dropoff_datetime >= '2019-10-01' AND
    lpep_dropoff_datetime < '2019-11-01';

SELECT
    DATE(lpep_pickup_datetime::timestamp) AS pickup_day,
    MAX(trip_distance) AS longest_trip_distance
FROM
    public.yellow_taxi_trips
GROUP BY
    pickup_day
ORDER BY
    longest_trip_distance DESC
LIMIT 1;


SELECT
	CONCAT(zpu."Borough", ' | ', zpu."Zone") AS "pickup_loc",
    SUM(total_amount) as total
FROM 
    yellow_taxi_trips t,
    zones zpu
WHERE
	t."PULocationID" = zpu."LocationID"
    AND DATE(lpep_pickup_datetime)='2019-10-18'
GROUP BY
	"pickup_loc"
ORDER BY
	total DESC;


SELECT
    zdo."Zone" AS "dropff_loc",
    MAX(t.tip_amount) AS total_tip_amount
FROM 
    yellow_taxi_trips t,
    zones zpu,
	zones zdo
WHERE
	t."PULocationID" = zpu."LocationID"
	AND t."DOLocationID" = zdo."LocationID"
    AND EXTRACT(YEAR FROM lpep_pickup_datetime::timestamp) = 2019 
	AND EXTRACT(MONTH FROM lpep_pickup_datetime::timestamp) = 10 
	AND zpu."Zone" ilike '%East Harlem North%'
GROUP BY
	"dropff_loc"
ORDER BY
	total_tip_amount DESC;