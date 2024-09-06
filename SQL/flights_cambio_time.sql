-- Query para corregir columnas de tiempo
-- De INTEGER a STRING (4 digitos) a formato TIME
WITH formatted_times AS (
  SELECT
    FL_DATE,
    AIRLINE_CODE,
    DOT_CODE,
    FL_NUMBER,
    ORIGIN,
    ORIGIN_CITY,
    DEST,
    DEST_CITY,
    FORMAT('%04d', CRS_DEP_TIME) AS CRS_DEP_TIME_STRING,
    FORMAT('%04d', DEP_TIME) AS DEP_TIME_STRING,
    FORMAT('%04d', WHEELS_OFF) AS WHEELS_OFF_STRING,
    FORMAT('%04d', WHEELS_ON) AS WHEELS_ON_STRING,
    FORMAT('%04d', ARR_TIME) AS ARR_TIME_STRING,
    DEP_DELAY,
    TAXI_OUT,
    TAXI_IN,
    ARR_DELAY,
    CRS_ELAPSED_TIME,
    ELAPSED_TIME,
    AIR_TIME,
    DISTANCE,
    DELAY_DUE_CARRIER,
    DELAY_DUE_WEATHER,
    DELAY_DUE_NAS,
    DELAY_DUE_SECURITY,
    DELAY_DUE_LATE_AIRCRAFT,
    EXTRACT(YEAR FROM DATE(FL_DATE)) AS FL_YEAR,
    EXTRACT(MONTH FROM DATE(FL_DATE)) AS FL_MONTH,
    EXTRACT(DAY FROM DATE(FL_DATE)) AS FL_DAY,
    CANCELLED,
    CANCELLATION_CODE,
    DIVERTED
  FROM
    `proyecto4-vuelos.procesos_vuelos.flights_sin_nulos`
),
corrected_times AS (
  SELECT
    FL_DATE,
    AIRLINE_CODE,
    DOT_CODE,
    FL_NUMBER,
    ORIGIN,
    ORIGIN_CITY,
    DEST,
    DEST_CITY,
    -- Correct '2400' to '0000' and convert to TIME
    CASE WHEN CRS_DEP_TIME_STRING = '2400' THEN '0000' ELSE CRS_DEP_TIME_STRING END AS CRS_DEP_TIME_STRING,
    CASE WHEN DEP_TIME_STRING = '2400' THEN '0000' ELSE DEP_TIME_STRING END AS DEP_TIME_STRING,
    CASE WHEN WHEELS_OFF_STRING = '2400' THEN '0000' ELSE WHEELS_OFF_STRING END AS WHEELS_OFF_STRING,
    CASE WHEN WHEELS_ON_STRING = '2400' THEN '0000' ELSE WHEELS_ON_STRING END AS WHEELS_ON_STRING,
    CASE WHEN ARR_TIME_STRING = '2400' THEN '0000' ELSE ARR_TIME_STRING END AS ARR_TIME_STRING,
    DEP_DELAY,
    TAXI_OUT,
    TAXI_IN,
    ARR_DELAY,
    CRS_ELAPSED_TIME,
    ELAPSED_TIME,
    AIR_TIME,
    DISTANCE,
    DELAY_DUE_CARRIER,
    DELAY_DUE_WEATHER,
    DELAY_DUE_NAS,
    DELAY_DUE_SECURITY,
    DELAY_DUE_LATE_AIRCRAFT,
    FL_YEAR,
    FL_MONTH,
    FL_DAY,
    CANCELLED,
    CANCELLATION_CODE,
    DIVERTED
  FROM
    formatted_times
)
SELECT
  FL_DATE,
  AIRLINE_CODE,
  DOT_CODE,
  FL_NUMBER,
  ORIGIN,
  ORIGIN_CITY,
  DEST,
  DEST_CITY,
  PARSE_TIME('%H%M', CRS_DEP_TIME_STRING) AS CRS_DEP_TIME,
  PARSE_TIME('%H%M', DEP_TIME_STRING) AS DEP_TIME,
  DEP_DELAY,
  TAXI_OUT,
  PARSE_TIME('%H%M', WHEELS_OFF_STRING) AS WHEELS_OFF,
  PARSE_TIME('%H%M', WHEELS_ON_STRING) AS WHEELS_ON,
  TAXI_IN,
  PARSE_TIME('%H%M', ARR_TIME_STRING) AS ARR_TIME,
  ARR_DELAY,
  CANCELLED,
  CANCELLATION_CODE,
  DIVERTED,
  CRS_ELAPSED_TIME,
  ELAPSED_TIME,
  AIR_TIME,
  DISTANCE,
  DELAY_DUE_CARRIER,
  DELAY_DUE_WEATHER,
  DELAY_DUE_NAS,
  DELAY_DUE_SECURITY,
  DELAY_DUE_LATE_AIRCRAFT,
  FL_YEAR,
  FL_MONTH,
  FL_DAY
FROM
  corrected_times;
