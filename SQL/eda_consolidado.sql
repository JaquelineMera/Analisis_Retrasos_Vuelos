-- Consultas para corroborar datos --

-- Query Total 
SELECT * 
FROM `proyecto4-vuelos.procesos_vuelos.flights_consolidado` 
;
-- Query Total de retrasos
SELECT * 
FROM `proyecto4-vuelos.procesos_vuelos.flights_consolidado` 
WHERE STATUS_VUELO = 'RETRASO';

-- Query para ver el grupo expuesto CARRIER - 63,154
SELECT * 
FROM `proyecto4-vuelos.procesos_vuelos.flights_consolidado` 
WHERE DELAY_DUE_CARRIER > 0;

-- Query para ver el grupo no expuesto CARRIER - 95,186
-- Todos los que son retraso por cualquier motivo
SELECT * 
FROM `proyecto4-vuelos.procesos_vuelos.flights_consolidado` 
WHERE EXCLUDING_CARRIER = 1;

-- Query para ver el grupo no expuesto CARRIER - 53559 rr_delays
-- Todos los que son retraso por cualquier motivo excepto CARRIER
SELECT * 
FROM `proyecto4-vuelos.procesos_vuelos.flights_consolidado` 
WHERE DELAY_DUE_CARRIER = 0 
  AND (DELAY_DUE_WEATHER > 0 
       OR DELAY_DUE_NAS > 0 
       OR DELAY_DUE_SECURITY > 0 
       OR DELAY_DUE_LATE_AIRCRAFT > 0);

-- Query para ver el grupo expuesto del aeropuerto PPG
SELECT * 
FROM `proyecto4-vuelos.procesos_vuelos.flights_consolidado` 
WHERE ORIGIN = 'PPG' ;

-- Query para ver el grupo total de grupo expuesto la aerolinea F9 13,285
SELECT * 
FROM `proyecto4-vuelos.procesos_vuelos.flights_consolidado` 
WHERE AIRLINE_CODE = 'F9' ;

-- Query para ver el grupo expuesto de la aerolinea F9
SELECT * 
FROM `proyecto4-vuelos.procesos_vuelos.flights_consolidado` 
WHERE AIRLINE_CODE = 'F9'AND STATUS_VUELO = 'RETRASO';

-- Query Aeropuertos sin retrasos COD y SMX
SELECT
    ORIGIN,
    ORIGIN_CITY
FROM
    `proyecto4-vuelos.procesos_vuelos.flights_consolidado`
GROUP BY
    ORIGIN, ORIGIN_CITY
HAVING
    COUNTIF(STATUS_VUELO = 'RETRASO') = 0;

-- Query horas sin retrasos 
SELECT
    EXTRACT(HOUR FROM TIME(CRS_DEP_TIME))
FROM
    `proyecto4-vuelos.procesos_vuelos.flights_consolidado`
GROUP BY
    CRS_DEP_TIME
HAVING
    COUNTIF(STATUS_VUELO = 'RETRASO') = 0;