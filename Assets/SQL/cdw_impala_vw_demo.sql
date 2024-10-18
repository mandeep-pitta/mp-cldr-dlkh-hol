--
-- QUERY TO SEE DATA LOADED FROM CDE
SELECT year, count(*) 
FROM ${prefix}_airlines.flights
GROUP BY year
ORDER BY year desc;

--
-- Typical analytic query patterns that need to be run

-- RUN EXPLAIN PLAN ON THIS QUERY
SELECT year, month, count(*) 
FROM ${prefix}_airlines.flights
WHERE year = 2006 AND month = 12
GROUP BY year, month
ORDER BY year desc, month asc;

-- RUN EXPLAIN PLAN ON THIS QUERY; AND COMPARE RESULTS
SELECT year, month, count(*) 
FROM ${prefix}_airlines.flights
WHERE year = 2007 AND month = 12
GROUP BY year, month
ORDER BY year desc, month asc;

--
-- SELECT SNAPSHOSTS THAT HAVE BEEN CREATED
DESCRIBE HISTORY ${prefix}_airlines.flights;

-- SELECT DATA USING TIMESTAMP FOR SNAPSHOT
SELECT year, count(*) 
FROM ${prefix}_airlines.flights
  FOR SYSTEM_TIME AS OF '${create_ts}'
GROUP BY year
ORDER BY year desc;

-- SELECT DATA USING TIMESTAMP FOR SNAPSHOT
SELECT year, count(*) 
FROM ${prefix}_airlines.flights
  FOR SYSTEM_VERSION AS OF ${snapshot_id}
GROUP BY year
ORDER BY year desc;
--
-- [optional] SINGLE QUERY USING ICEBERG & HIVE TABLE FORMAT
--            Uses CDV Dashboard, could also just query in HUE
-- DESCRIBE FORMATTED ${prefix}_airlines.flights;
DESCRIBE FORMATTED ${prefix}_airlines.unique_tickets;

-- [optional] Query combining Hive Table Format (unique_tickets) and Iceberg Table Format (flights)
SELECT 
t.leg1origin,
f.dest,
count(*) as num_passengers
FROM ${prefix}_airlines.unique_tickets t
LEFT OUTER JOIN ${prefix}_airlines.flights f ON
  t.leg1origin = f.origin
  AND t.leg1dest = f.dest
  AND t.leg1flightnum = f.flightnum
  AND t.leg1month = f.month
  AND t.leg1dayofmonth = f.dayofmonth
GROUP BY t.leg1origin, f.dest;


--
-- SDX FINE GRAINED ACCESS CONTROL
--     1. Run query to see Tailnum in plain text
--     2. Ranger - enable policy
--     3. Run query again to see Tailnum is Hashed
SELECT * FROM ${prefix}_airlines.planes;
