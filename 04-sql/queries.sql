-- =====================================================================
-- IT'S NOT ABOUT THE TOOL (v2)  |  Episode: SQL
-- Four ONS sheets: Table_6, Table_9, Table_10, Table_11
-- Tool: DB Browser for SQLite (free). PART A cleans, PART B answers Q1-Q5.
-- Run one query at a time: click inside it, press Ctrl + Shift + F5.
--
-- BEFORE YOU START (Excel, 4 minutes): open alcoholspecificdeaths2024.xlsx and
-- save each sheet separately as CSV UTF-8 (File > Save As, with that sheet open):
--     Table_6  -> t6_raw.csv      Table_9  -> t9_raw.csv
--     Table_10 -> t10_raw.csv     Table_11 -> t11_raw.csv
-- THEN: New Database > alcohol.db > Cancel the pop-up.
--   File > Import > Table from CSV file, four times. Table names: raw6, raw9,
--   raw10, raw11. UNTICK "Column names in first line" every time.
--   You get columns field1, field2, ... Then run PART A.
-- =====================================================================


-- =========================== PART A: CLEAN ===========================
-- The pattern is the same every time:
--   keep only rows whose key column is a 4-digit year  -> drops titles, notes, headers
--   TRIM()        -> removes stray spaces
--   REPLACE(,',') -> removes the thousands commas Excel writes
--   CAST()        -> stores numbers as numbers, so sorting and maths work

-- A1. Regions (Table_6). Expect 648 rows after cleaning.
DROP TABLE IF EXISTS t6;
CREATE TABLE t6 AS
SELECT CAST(TRIM(field1) AS INTEGER)                   AS Year,
       TRIM(field2)                                    AS Sex,
       TRIM(field3)                                    AS AreaCode,
       TRIM(field4)                                    AS Region,
       CAST(REPLACE(TRIM(field5), ',', '') AS INTEGER) AS Deaths,
       CAST(TRIM(field6) AS REAL)                      AS Rate,
       CAST(TRIM(field7) AS REAL)                      AS LCL,
       CAST(TRIM(field8) AS REAL)                      AS UCL
FROM raw6
WHERE TRIM(field1) GLOB '[0-9][0-9][0-9][0-9]';

-- A2. Causes with age bands (Table_9). Expect 1080 rows.
DROP TABLE IF EXISTS t9;
CREATE TABLE t9 AS
SELECT CAST(TRIM(field3) AS INTEGER)                    AS Year,
       TRIM(field4)                                     AS Sex,
       TRIM(field5)                                     AS ICD,
       TRIM(field6)                                     AS Cause,
       CAST(REPLACE(TRIM(field27), ',', '') AS INTEGER) AS Deaths
FROM raw9
WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]';

-- A3. Cause shares (Table_10). Expect 1080 rows.
DROP TABLE IF EXISTS t10;
CREATE TABLE t10 AS
SELECT CAST(TRIM(field3) AS INTEGER) AS Year,
       TRIM(field4)                  AS Sex,
       TRIM(field5)                  AS ICD,
       TRIM(field6)                  AS Cause,
       CAST(TRIM(field7) AS REAL)    AS Proportion
FROM raw10
WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]';

-- A4. Deprivation (Table_11). Expect 35 rows.
DROP TABLE IF EXISTS t11;
CREATE TABLE t11 AS
SELECT CAST(TRIM(field1) AS INTEGER)                    AS Year,
       CAST(TRIM(field2) AS INTEGER)                    AS IMD_Quintile,
       CAST(REPLACE(TRIM(field3), ',', '') AS INTEGER)  AS Male_Deaths,
       CAST(TRIM(field4) AS REAL)                       AS Male_Rate,
       CAST(REPLACE(TRIM(field7), ',', '') AS INTEGER)  AS Female_Deaths,
       CAST(TRIM(field8) AS REAL)                       AS Female_Rate
FROM raw11
WHERE TRIM(field1) GLOB '[0-9][0-9][0-9][0-9]';

-- A5. Age bands, one row per band (Table_9 is 20 columns wide; this makes it tall).
DROP TABLE IF EXISTS t9_age;
CREATE TABLE t9_age AS
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '<1' AS Age_band, CAST(REPLACE(TRIM(field7), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '01-04' AS Age_band, CAST(REPLACE(TRIM(field8), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '05-09' AS Age_band, CAST(REPLACE(TRIM(field9), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '10-14' AS Age_band, CAST(REPLACE(TRIM(field10), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '15-19' AS Age_band, CAST(REPLACE(TRIM(field11), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '20-24' AS Age_band, CAST(REPLACE(TRIM(field12), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '25-29' AS Age_band, CAST(REPLACE(TRIM(field13), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '30-34' AS Age_band, CAST(REPLACE(TRIM(field14), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '35-39' AS Age_band, CAST(REPLACE(TRIM(field15), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '40-44' AS Age_band, CAST(REPLACE(TRIM(field16), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '45-49' AS Age_band, CAST(REPLACE(TRIM(field17), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '50-54' AS Age_band, CAST(REPLACE(TRIM(field18), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '55-59' AS Age_band, CAST(REPLACE(TRIM(field19), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '60-64' AS Age_band, CAST(REPLACE(TRIM(field20), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '65-69' AS Age_band, CAST(REPLACE(TRIM(field21), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '70-74' AS Age_band, CAST(REPLACE(TRIM(field22), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '75-79' AS Age_band, CAST(REPLACE(TRIM(field23), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '80-84' AS Age_band, CAST(REPLACE(TRIM(field24), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '85-89' AS Age_band, CAST(REPLACE(TRIM(field25), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]'
    UNION ALL
    SELECT CAST(TRIM(field3) AS INTEGER) AS Year, TRIM(field4) AS Sex, '90+' AS Age_band, CAST(REPLACE(TRIM(field26), ',', '') AS INTEGER) AS Deaths FROM raw9 WHERE TRIM(field3) GLOB '[0-9][0-9][0-9][0-9]';

-- A6. CHECK before you go on. Expect 648 | 1080 | 1080 | 35 | 21600.
SELECT (SELECT COUNT(*) FROM t6)     AS t6_rows,
       (SELECT COUNT(*) FROM t9)     AS t9_rows,
       (SELECT COUNT(*) FROM t10)    AS t10_rows,
       (SELECT COUNT(*) FROM t11)    AS t11_rows,
       (SELECT COUNT(*) FROM t9_age) AS t9_age_rows;

-- A7. CROSS-CHECK the two England tables agree. Expect every row to say MATCH.
SELECT a.Year, a.deaths_t6, b.deaths_t11,
       CASE WHEN a.deaths_t6 = b.deaths_t11 THEN 'MATCH' ELSE 'PROBLEM' END AS verdict
FROM (SELECT Year, SUM(Deaths) AS deaths_t6 FROM t6 WHERE Sex = 'Persons' GROUP BY Year) a
JOIN (SELECT Year, SUM(Male_Deaths + Female_Deaths) AS deaths_t11 FROM t11 GROUP BY Year) b
  ON a.Year = b.Year
ORDER BY a.Year;

-- Press Ctrl + S (Write Changes) before moving on.


-- ========================== PART B: ANALYSE ==========================

-- Q1. WHERE is it worst? England regions, 2024.
--     Expect: North East 21.1 (19.4 to 22.9) top, London 10.9 bottom.
--     The CASE line answers "is the gap real?" without any statistics jargon.
SELECT Region, Deaths, Rate, LCL, UCL,
       CASE WHEN LCL > (SELECT MAX(UCL) FROM t6 WHERE Year = 2024 AND Sex = 'Persons'
                        AND Region = 'London')
            THEN 'Clearly above London' ELSE 'Overlaps London' END AS vs_london
FROM t6
WHERE Year = 2024 AND Sex = 'Persons'
ORDER BY Rate DESC;

-- Q2. WHEN: deaths per year, and the change on 2019 and 2023.
--     Expect: 5,820 (2019), 8,276 (2023), 7,673 (2024), +31.8% and -7.3%.
WITH yearly AS (
    SELECT Year, SUM(Deaths) AS Deaths FROM t6 WHERE Sex = 'Persons' GROUP BY Year)
SELECT Year, Deaths,
       ROUND(100.0 * (Deaths - (SELECT Deaths FROM yearly WHERE Year = 2019))
             / (SELECT Deaths FROM yearly WHERE Year = 2019), 1) AS pct_vs_2019
FROM yearly ORDER BY Year;

-- Q3. WHAT are people dying of? UK, 2024. Counts joined to published shares.
--     Expect: alcoholic liver disease 7,288 deaths = 74.3% of 9,809.
SELECT t9.Cause, t9.Deaths, t10.Proportion AS pct_of_UK_deaths
FROM t9 JOIN t10 ON t9.Year = t10.Year AND t9.Sex = t10.Sex AND t9.ICD = t10.ICD
WHERE t9.Year = 2024 AND t9.Sex = 'Persons' AND t9.Deaths > 0
ORDER BY t9.Deaths DESC;

-- Q3b. Has the mix changed? Liver disease share, selected years.
--      Expect: 77.8% in 2001, 77.2% in 2019, 74.3% in 2024.
SELECT Year, Proportion AS liver_disease_pct
FROM t10 WHERE ICD = 'K70' AND Sex = 'Persons' AND Year IN (2001, 2019, 2024)
ORDER BY Year;

-- Q4. WHO: age at death, UK, 2024. Expect 55-59 highest at 16.8% of deaths.
WITH by_band AS (
    SELECT Age_band, SUM(Deaths) AS Deaths FROM t9_age
    WHERE Year = 2024 AND Sex = 'Persons' GROUP BY Age_band)
SELECT Age_band, Deaths,
       ROUND(100.0 * Deaths / (SELECT SUM(Deaths) FROM by_band), 1) AS pct_of_deaths
FROM by_band WHERE Deaths > 0 ORDER BY Deaths DESC;

-- Q5. Does deprivation explain it? England, 2024.
--     Expect: men 35.7 in the most deprived fifth vs 9.0 in the least = 3.97 times.
SELECT IMD_Quintile,
       Male_Deaths, Male_Rate, Female_Deaths, Female_Rate,
       ROUND(Male_Rate / Female_Rate, 2) AS male_to_female
FROM t11 WHERE Year = 2024 ORDER BY IMD_Quintile;

SELECT ROUND(MAX(CASE WHEN IMD_Quintile = 1 THEN Male_Rate END) /
             MAX(CASE WHEN IMD_Quintile = 5 THEN Male_Rate END), 2) AS male_ratio_most_vs_least,
       ROUND(MAX(CASE WHEN IMD_Quintile = 1 THEN Female_Rate END) /
             MAX(CASE WHEN IMD_Quintile = 5 THEN Female_Rate END), 2) AS female_ratio_most_vs_least
FROM t11 WHERE Year = 2024;

-- CHARTS (View > Plot after running a query):
--   Q1 X Region, Y Rate (Bars) | Q2 X Year, Y Deaths (Line)
--   Q3 X Cause, Y Deaths (Bars) | Q4 X Age_band, Y pct_of_deaths (Bars)
--   Q5 X IMD_Quintile, Y Male_Rate + Female_Rate (Bars)


-- ============== SPOTLIGHT: what only SQL does best ==============
-- Window functions and saved views. A window function ranks or compares rows
-- WITHOUT collapsing them, so you keep the detail and the ranking in one result.

-- S1. Rank regions each year, and show each region's movement up or down the table.
--     Expect: North East rank 1 in every year shown.
SELECT Year, Region, Rate,
       RANK()  OVER (PARTITION BY Year ORDER BY Rate DESC)                 AS rank_this_year,
       LAG(Rate) OVER (PARTITION BY Region ORDER BY Year)                  AS rate_last_year,
       ROUND(Rate - LAG(Rate) OVER (PARTITION BY Region ORDER BY Year), 1) AS change_on_last_year
FROM t6
WHERE Sex = 'Persons' AND Year >= 2019
ORDER BY Year DESC, rank_this_year;

-- S2. A three-year rolling average, which smooths the single-year wobble.
--     Expect 2024 rolling average of about 7,954 deaths.
WITH yearly AS (
    SELECT Year, SUM(Deaths) AS Deaths FROM t6 WHERE Sex = 'Persons' GROUP BY Year)
SELECT Year, Deaths,
       ROUND(AVG(Deaths) OVER (ORDER BY Year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)) AS rolling_3yr
FROM yearly ORDER BY Year;

-- S3. Save the headline as a VIEW, so the dashboard query is one line forever.
DROP VIEW IF EXISTS v_region_2024;
CREATE VIEW v_region_2024 AS
SELECT Region, Deaths, Rate, LCL, UCL,
       RANK() OVER (ORDER BY Rate DESC) AS rank_2024
FROM t6 WHERE Year = 2024 AND Sex = 'Persons';

SELECT * FROM v_region_2024 ORDER BY rank_2024;
