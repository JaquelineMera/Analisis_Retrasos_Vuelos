--Vuelos con salidas retrasadas 202,779
SELECT
*
FROM `proyecto4-vuelos.dataset_vuelos.flights_202301`
WHERE DEP_DELAY > 0;
--Vuelos con salidas retrasadas suma de minutos 8,542,316
SELECT
  SUM(DEP_DELAY) AS total_dep_delay
FROM
  `proyecto4-vuelos.dataset_vuelos.flights_202301`
WHERE
  DEP_DELAY > 0;

--Vuelos que llegan retrasados 202,575
SELECT
*
FROM `proyecto4-vuelos.dataset_vuelos.flights_202301`
WHERE ARR_DELAY > 0;
--Vuelos que llegan retrasados suma de minutos 8,666,535
SELECT
  SUM(ARR_DELAY) AS total_arr_delay
FROM
  `proyecto4-vuelos.dataset_vuelos.flights_202301`
WHERE
  ARR_DELAY > 0;

---Vuelos retrasados por Carrier 63,154
SELECT
*
FROM `proyecto4-vuelos.dataset_vuelos.flights_202301`
WHERE DELAY_DUE_CARRIER > 0;
--Vuelos retrasados por Carrier suma de minutos 2,860,559
SELECT
  SUM(DELAY_DUE_CARRIER) AS total_due_carrier
FROM
  proyecto4-vuelos.dataset_vuelos.flights_202301
WHERE
  DELAY_DUE_CARRIER > 0;

---Vuelos retrasados por Weather 6,507
SELECT
*
FROM `proyecto4-vuelos.dataset_vuelos.flights_202301`
WHERE DELAY_DUE_WEATHER> 0;
--Vuelos retrasados por Weather suma de minutos 511,666
SELECT
  SUM(DELAY_DUE_WEATHER) AS total_due_weather
FROM
  proyecto4-vuelos.dataset_vuelos.flights_202301
WHERE
  DELAY_DUE_WEATHER > 0;

---Vuelos retrasados por NAS 59,712
SELECT
*
FROM `proyecto4-vuelos.dataset_vuelos.flights_202301`
WHERE DELAY_DUE_NAS> 0;
--Vuelos retrasados por NAS suma de minutos 1,709,669
SELECT
  SUM(DELAY_DUE_NAS) AS total_due_nas
FROM
  proyecto4-vuelos.dataset_vuelos.flights_202301
WHERE
  DELAY_DUE_NAS > 0;

---Vuelos retrasados por SECURITY 626
SELECT
*
FROM `proyecto4-vuelos.dataset_vuelos.flights_202301`
WHERE DELAY_DUE_SECURITY> 0;
--Vuelos retrasados por SECURITY suma de minutos 17,069 
SELECT
  SUM(DELAY_DUE_SECURITY) AS total_due_security
FROM
  proyecto4-vuelos.dataset_vuelos.flights_202301
WHERE
  DELAY_DUE_SECURITY > 0;

---Vuelos retrasados por LATE_AIRCFRAFT 54,083
SELECT
*
FROM `proyecto4-vuelos.dataset_vuelos.flights_202301`
WHERE DELAY_DUE_LATE_AIRCRAFT> 0;
--Vuelos retrasados por LATE AIRCRAFT suma de minutos 3,006,030 
SELECT
  SUM(DELAY_DUE_LATE_AIRCRAFT) AS total_due_late_aircraft
FROM
  proyecto4-vuelos.dataset_vuelos.flights_202301
WHERE
  DELAY_DUE_LATE_AIRCRAFT > 0;

---Vuelos retrasados sin valor en las variables DELAY_DUE_REASON "NO RETRASOS 1-14MIN"
-- Total de vuelos "NO RETRASO" 85,862
-- Minutos 561,542
WITH vuelos_retrasados_sin_motivo AS (
  SELECT
    *
  FROM
    `proyecto4-vuelos.dataset_vuelos.flights_202301`
  WHERE
    ARR_DELAY > 0
    AND DELAY_DUE_LATE_AIRCRAFT IS NULL
    AND DELAY_DUE_CARRIER IS NULL
    AND DELAY_DUE_WEATHER IS NULL
    AND DELAY_DUE_SECURITY IS NULL
    AND DELAY_DUE_NAS IS NULL
)
SELECT
  COUNT(*) AS total_vuelos_retrasados_sin_motivo,
  SUM(ARR_DELAY) AS total_arr_delay_sin_motivo
FROM
  vuelos_retrasados_sin_motivo;

---Vuelos que salen retrasados y que llegan retrasados 147,905
SELECT
  *
FROM
  `proyecto4-vuelos.dataset_vuelos.flights_202301`
WHERE
  ARR_DELAY > 0
  AND DEP_DELAY > 0;