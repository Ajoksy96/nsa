/* Creating tables to import cleaned data from Python into 
SQL via CSV */
CREATE TABEL pbj
(pbj_id VARCHAR(150),
fac_name VARCHAR(750),
city VARCHAR(150),
fac_state VARCHAR(150),
county VARCHAR(150),
date DATE,
num_residents INTEGER,
tot_nurse_hrs DECIMAL,
emp_nurse_hrs DECIMAL,
contr_nurse_hrs DECIMAL,
tot_nursehrs_perres DECIMAL,
savg_num_residents DECIMAL,
savg_nursehrs_perres_day DECIMAL,
savg_nursehrs_perres_weekend DECIMAL,
savg_nurse_turnover DECIMAL);

CREATE TABLE cms
(cms_id VARCHAR(150),
fac_name VARCHAR(750),
fac_state VARCHAR(150),
zipcode VARCHAR(150),
fac_type VARCHAR(750),
num_beds INTEGER,
avg_residents_per_day DECIMAL,
in_hospital INTEGER,
retirement_community INTEGER,
abuse_citation INTEGER,
overall_rating DECIMAL,
health_rating DECIMAL,
quality_rating DECIMAL,
staff_rating DECIMAL,
nursehrs_perres_perday DECIMAL,
nursehrs_perres_perweekend DECIMAL,
weighted_health_score DECIMAL,
penalties INTEGER,
latitude DECIMAL,
longitude DECIMAL,
savg_num_residents DECIMAL,
savg_nursehrs_perres_day DECIMAL,
savg_nursehrs_perres_weekend DECIMAL,
savg_nurse_turnover DECIMAL);


/* Facilities below legal requirements for nursing hours 
per day per resident that also did not have any contractors 
and number of days they met these criteria in Q1 */
SELECT fac_name, fac_state, COUNT(fac_name) AS days_below_req
FROM pbj
WHERE (3.48 - tot_nursehrs_perres) > 0 AND (contr_nurse_hrs = 0)
GROUP BY fac_name, fac_state
ORDER BY COUNT(fac_name) DESC
LIMIT 10;

/* Which facilities are below legal requirements 
for nursing hours per day per resident on average and by how much on average 
were they below the requirement */
SELECT fac_name, fac_state, (3.48 - nursehrs_perres_perday) AS avg_hrs_below_req
FROM cms
WHERE (3.48 - nursehrs_perres_perday) IS NOT NULL
ORDER BY (3.48 - nursehrs_perres_perday) DESC
LIMIT 10;


/* Which states have the most days in which their facilities both do not 
meet legal requirements for nursing hours per day per resident and do not 
have any contractors in Q1 */
SELECT fac_state, COUNT(fac_name) AS days_below_req
FROM pbj
WHERE (3.48 - tot_nursehrs_perres) > 0 AND (contr_nurse_hrs = 0)
GROUP BY fac_state
ORDER BY COUNT(fac_name) DESC;

/* Which states have the most facilities whose average nursing hours per day per resident 
do not meet legal requirements */
SELECT fac_state, COUNT(fac_state) AS numoffac_underreq_onavg
FROM cms
WHERE (3.48 - nursehrs_perres_perday) > 0 AND 
(3.48 - nursehrs_perres_perday) IS NOT NULL
GROUP BY fac_state
ORDER BY COUNT(fac_name) DESC;


/* How many facilities did not meet legal requirements for nursing hours 
per day per resident and did not have any contractors on each day of Q1 */
SELECT date_day, COUNT(fac_name) AS fac_below_req
FROM pbj
WHERE (3.48 - tot_nursehrs_perres) > 0 AND (contr_nurse_hrs = 0)
GROUP BY date_day
ORDER BY date_day ASC;

/* How many facilities did not meet legal requirements for nursing hours 
per day per resident and did not have any contractors in each month of Q1 */
SELECT EXTRACT(MONTH FROM date_day) AS month, COUNT(fac_name) AS fac_below_req
FROM pbj
WHERE (3.48 - tot_nursehrs_perres) > 0 AND (contr_nurse_hrs = 0)
GROUP BY EXTRACT(MONTH FROM date_day)
ORDER BY EXTRACT(MONTH FROM date_day) ASC;

/* How many facilities did not meet legal requirements for nursing hours 
per day per resident and did not have any contractors on each day of the month in Q1 */
SELECT EXTRACT(DAY FROM date_day) AS day, COUNT(fac_name) AS fac_below_req
FROM pbj
WHERE (3.48 - tot_nursehrs_perres) > 0 AND (contr_nurse_hrs = 0)
GROUP BY EXTRACT(DAY FROM date_day)
ORDER BY EXTRACT(DAY FROM date_day) ASC;

/* How many facilities did not meet legal requirements for nursing hours 
per day per resident and did not have any contractors on each day of the week in Q1 */
SELECT EXTRACT(DOW FROM date_day) AS day, COUNT(fac_name) AS fac_below_req
FROM pbj
WHERE (3.48 - tot_nursehrs_perres) > 0 AND (contr_nurse_hrs = 0)
GROUP BY EXTRACT(DOW FROM date_day)
ORDER BY EXTRACT(DOW FROM date_day) ASC;


/* Which states have the most facilities that are below legal requirements 
for nursing hours per day per resident on average and have low quality */
SELECT fac_state, COUNT(fac_name) AS num_lowq_fac
FROM cms
WHERE (3.48 - nursehrs_perres_perday) > 0 AND (3.48 - nursehrs_perres_perday) IS NOT NULL AND
overall_rating = 1 AND health_rating = 1 AND quality_rating = 1 AND staff_rating = 1
GROUP BY fac_state
ORDER BY COUNT(*) DESC;


/* Which facilities are below legal requirements for nursing hours per day 
per resident on average and have low quality */
SELECT fac_name, fac_state, (3.48 - nursehrs_perres_perday) AS avg_hrs_below_req
FROM cms
WHERE (3.48 - nursehrs_perres_perday) > 0 AND (3.48 - nursehrs_perres_perday) IS NOT NULL AND
overall_rating = 1 AND health_rating = 1 AND quality_rating = 1 AND staff_rating = 1
ORDER BY (3.48 - nursehrs_perres_perday) DESC
LIMIT 10;
