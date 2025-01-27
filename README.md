# Module 1 Homework: Docker & SQL




## Question 1. Understanding docker first run 

```
docker run -it --entrypoint /bin/bash python:3.12.8
```
```
pip --version
```

## Question 2. Understanding Docker networking and docker-compose

We can use following host and port to connect to postgres
- postgres:5432
- db:5432

## Question 3. Trip Segmentation Count
```sql
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
```

## Question 4. Longest trip for each day

```sql
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
```

## Question 5. Three biggest pickup zones

```sql
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
	total DESC
 LIMIT 3;
```

## Question 6. Largest tip

```sql
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
```

## Terraform

## Question 7. Terraform Workflow

1. Downloading the provider plugins and setting up backend - teraform init,
2. Generating proposed changes and auto-executing the plan - terraform apply -auto-approve
3. Remove all resources managed by terraform - terraform destroy
