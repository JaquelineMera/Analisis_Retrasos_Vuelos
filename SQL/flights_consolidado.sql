SELECT
  f.FL_DATE,
  FORMAT_DATE('%A', f.FL_DATE) AS DAY_OF_WEEK,
  f.AIRLINE_CODE,
  f.DOT_CODE,
  f.FL_NUMBER,
  f.ORIGIN,
  f.ORIGIN_CITY,
  f.DEST,
  f.DEST_CITY,
  CONCAT(f.ORIGIN_CITY, ' - ', f.DEST_CITY) AS ROUTE_CITY,
  CONCAT(f.ORIGIN, ' - ', f.DEST) AS ROUTE_AIRPORT,  
  f.CRS_DEP_TIME,
  EXTRACT(HOUR FROM TIME(CRS_DEP_TIME)) AS HOUR_CRS_DEP_T,
  f.DEP_TIME,
  f.DEP_DELAY,
  f.TAXI_OUT,
  f.WHEELS_OFF,
  f.WHEELS_ON,
  f.TAXI_IN,
  f.ARR_TIME,
  f.ARR_DELAY,
  f.CANCELLED,
  f.CANCELLATION_CODE,
  f.DIVERTED,
  f.CRS_ELAPSED_TIME,
  f.ELAPSED_TIME,
  f.AIR_TIME,
  f.DISTANCE,
  NTILE(4) OVER (ORDER BY DISTANCE) AS DISTANCE_QUARTILE,
  f.DELAY_DUE_CARRIER,
  f.DELAY_DUE_WEATHER,
  f.DELAY_DUE_NAS,
  f.DELAY_DUE_SECURITY,
  f.DELAY_DUE_LATE_AIRCRAFT,
  (f.DELAY_DUE_CARRIER +
   f.DELAY_DUE_WEATHER +
   f.DELAY_DUE_NAS +
   f.DELAY_DUE_SECURITY +
   f.DELAY_DUE_LATE_AIRCRAFT) AS TOTAL_DELAY,
  IF(
    (f.DELAY_DUE_CARRIER + 
     f.DELAY_DUE_WEATHER + 
     f.DELAY_DUE_NAS + 
     f.DELAY_DUE_SECURITY + 
     f.DELAY_DUE_LATE_AIRCRAFT) > 0, 
    1, 
    0
  ) AS TOTAL_NUM_DELAY,
CASE
    WHEN (f.CANCELLED = 0 AND f.DIVERTED = 0 AND (f.DELAY_DUE_CARRIER + f.DELAY_DUE_WEATHER + f.DELAY_DUE_NAS + f.DELAY_DUE_SECURITY + f.DELAY_DUE_LATE_AIRCRAFT) = 0) THEN 'A TIEMPO'
    WHEN (f.CANCELLED = 0 AND f.DIVERTED = 0 AND (f.DELAY_DUE_CARRIER + f.DELAY_DUE_WEATHER + f.DELAY_DUE_NAS + f.DELAY_DUE_SECURITY + f.DELAY_DUE_LATE_AIRCRAFT) > 0) THEN 'RETRASO'
    WHEN (f.DIVERTED = 1 AND (f.DELAY_DUE_CARRIER + f.DELAY_DUE_WEATHER + f.DELAY_DUE_NAS + f.DELAY_DUE_SECURITY + f.DELAY_DUE_LATE_AIRCRAFT) = 0) THEN 'DESVIADO'
    WHEN (f.CANCELLED = 1 AND (f.DELAY_DUE_CARRIER + f.DELAY_DUE_WEATHER + f.DELAY_DUE_NAS + f.DELAY_DUE_SECURITY + f.DELAY_DUE_LATE_AIRCRAFT) = 0) THEN 'CANCELADO'
    ELSE 'OTRO' -- Esta condición captura cualquier caso no previsto
  END AS STATUS_VUELO, -- Nueva columna estado
    CASE
    WHEN f.CANCELLED = 1 AND f.CANCELLATION_CODE = 'A' THEN 'Cancelado por operador'
    WHEN f.CANCELLED = 1 AND f.CANCELLATION_CODE = 'B' THEN 'Cancelado por clima'
    WHEN f.CANCELLED = 1 AND f.CANCELLATION_CODE = 'C' THEN 'Cancelado por NAS'
    WHEN f.CANCELLED = 1 AND f.CANCELLATION_CODE = 'D' THEN 'Cancelado por seguridad'
    WHEN f.DIVERTED = 1 THEN 'Desviado'
    WHEN f.DELAY_DUE_CARRIER > 0 AND f.DELAY_DUE_WEATHER = 0 AND f.DELAY_DUE_NAS = 0 AND f.DELAY_DUE_SECURITY = 0 AND f.DELAY_DUE_LATE_AIRCRAFT = 0 THEN 'Retraso por operador'
    WHEN f.DELAY_DUE_WEATHER > 0 AND f.DELAY_DUE_CARRIER = 0 AND f.DELAY_DUE_NAS = 0 AND f.DELAY_DUE_SECURITY = 0 AND f.DELAY_DUE_LATE_AIRCRAFT = 0 THEN 'Retraso por clima'
    WHEN f.DELAY_DUE_NAS > 0 AND f.DELAY_DUE_CARRIER = 0 AND f.DELAY_DUE_WEATHER = 0 AND f.DELAY_DUE_SECURITY = 0 AND f.DELAY_DUE_LATE_AIRCRAFT = 0 THEN 'Retraso por NAS'
    WHEN f.DELAY_DUE_SECURITY > 0 AND f.DELAY_DUE_CARRIER = 0 AND f.DELAY_DUE_WEATHER = 0 AND f.DELAY_DUE_NAS = 0 AND f.DELAY_DUE_LATE_AIRCRAFT = 0 THEN 'Retraso por seguridad'
    WHEN f.DELAY_DUE_LATE_AIRCRAFT > 0 AND f.DELAY_DUE_CARRIER = 0 AND f.DELAY_DUE_WEATHER = 0 AND f.DELAY_DUE_NAS = 0 AND f.DELAY_DUE_SECURITY = 0 THEN 'Retraso por aeronave tardía'
    WHEN (f.DELAY_DUE_CARRIER > 0 AND (f.DELAY_DUE_WEATHER > 0 OR f.DELAY_DUE_NAS > 0 OR f.DELAY_DUE_SECURITY > 0 OR f.DELAY_DUE_LATE_AIRCRAFT > 0)) OR
         (f.DELAY_DUE_WEATHER > 0 AND (f.DELAY_DUE_CARRIER > 0 OR f.DELAY_DUE_NAS > 0 OR f.DELAY_DUE_SECURITY > 0 OR f.DELAY_DUE_LATE_AIRCRAFT > 0)) OR
         (f.DELAY_DUE_NAS > 0 AND (f.DELAY_DUE_CARRIER > 0 OR f.DELAY_DUE_WEATHER > 0 OR f.DELAY_DUE_SECURITY > 0 OR f.DELAY_DUE_LATE_AIRCRAFT > 0)) OR
         (f.DELAY_DUE_SECURITY > 0 AND (f.DELAY_DUE_CARRIER > 0 OR f.DELAY_DUE_WEATHER > 0 OR f.DELAY_DUE_NAS > 0 OR f.DELAY_DUE_LATE_AIRCRAFT > 0)) OR
         (f.DELAY_DUE_LATE_AIRCRAFT > 0 AND (f.DELAY_DUE_CARRIER > 0 OR f.DELAY_DUE_WEATHER > 0 OR f.DELAY_DUE_NAS > 0 OR f.DELAY_DUE_SECURITY > 0)) THEN 'Retraso multifactorial'
    ELSE 'A tiempo'
  END AS STATUS_VUELO_DES,
  IF(GREATEST(f.DELAY_DUE_WEATHER, f.DELAY_DUE_NAS, f.DELAY_DUE_SECURITY, f.DELAY_DUE_LATE_AIRCRAFT) > 0, 1, 0) AS EXCLUDING_CARRIER,
  IF(GREATEST(f.DELAY_DUE_CARRIER, f.DELAY_DUE_NAS, f.DELAY_DUE_SECURITY, f.DELAY_DUE_LATE_AIRCRAFT) > 0, 1, 0) AS EXCLUDING_WEATHER,
  IF(GREATEST(f.DELAY_DUE_CARRIER, f.DELAY_DUE_WEATHER, f.DELAY_DUE_SECURITY, f.DELAY_DUE_LATE_AIRCRAFT) > 0, 1, 0) AS EXCLUDING_NAS,
  IF(GREATEST(f.DELAY_DUE_CARRIER, f.DELAY_DUE_WEATHER, f.DELAY_DUE_NAS, f.DELAY_DUE_LATE_AIRCRAFT) > 0, 1, 0) AS EXCLUDING_SECURITY,
  IF(GREATEST(f.DELAY_DUE_CARRIER, f.DELAY_DUE_WEATHER, f.DELAY_DUE_NAS, f.DELAY_DUE_SECURITY) > 0, 1, 0) AS EXCLUDING_LATE_AIRCRAFT,
  f.FL_YEAR,
  f.FL_MONTH,
  f.FL_DAY,
  acd.Description AS DESCRIPTION_AIRLINE,  
  dcl.Description AS DESCRIPTION_DOT 

FROM
  `proyecto4-vuelos.procesos_vuelos.flights_cambio_time` AS f
LEFT JOIN
  `proyecto4-vuelos.dataset_vuelos.airline_code_dictionary` AS acd
  ON f.AIRLINE_CODE = acd.Code
LEFT JOIN
  `proyecto4-vuelos.procesos_vuelos.dot_code_limpio` AS dcl
  ON f.DOT_CODE = dcl.Code;