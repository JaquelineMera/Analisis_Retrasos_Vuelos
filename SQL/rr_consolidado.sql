WITH delay_counts AS (
  SELECT
    -- Contar los casos con retraso por operador y otros retrasos
    COUNTIF(DELAY_DUE_CARRIER > 0) AS exposed_carrier_delay,
    COUNTIF(EXCLUDING_CARRIER > 0 AND DELAY_DUE_CARRIER = 0) AS unexposed_carrier_delay,

    -- Contar los casos con retraso por clima y otros retrasos
    COUNTIF(DELAY_DUE_WEATHER > 0) AS exposed_weather_delay,
    COUNTIF(EXCLUDING_WEATHER > 0 AND DELAY_DUE_WEATHER = 0) AS unexposed_weather_delay,

    -- Contar los casos con retraso por NAS y otros retrasos
    COUNTIF(DELAY_DUE_NAS > 0) AS exposed_nas_delay,
    COUNTIF(EXCLUDING_NAS > 0 AND DELAY_DUE_NAS = 0) AS unexposed_nas_delay,

    -- Contar los casos con retraso por seguridad y otros retrasos
    COUNTIF(DELAY_DUE_SECURITY > 0) AS exposed_security_delay,
    COUNTIF(EXCLUDING_SECURITY > 0 AND DELAY_DUE_SECURITY = 0) AS unexposed_security_delay,

    -- Contar los casos con retraso por aeronave tardía y otros retrasos
    COUNTIF(DELAY_DUE_LATE_AIRCRAFT > 0) AS exposed_late_aircraft_delay,
    COUNTIF(EXCLUDING_LATE_AIRCRAFT > 0 AND DELAY_DUE_LATE_AIRCRAFT = 0) AS unexposed_late_aircraft_delay,

    COUNT(*) AS total_flights
  FROM
    `proyecto4-vuelos.procesos_vuelos.flights_consolidado`
)

SELECT
  'Operador' AS motivo,
  exposed_carrier_delay AS exposed_count,
  unexposed_carrier_delay AS unexposed_count,
  (exposed_carrier_delay / total_flights) AS exposed_rate,
  (unexposed_carrier_delay / total_flights) AS unexposed_rate, 
  ((exposed_carrier_delay / total_flights)/ (unexposed_carrier_delay / total_flights)) AS relative_risk,
  total_flights
FROM delay_counts

UNION ALL

SELECT
  'Clima' AS motivo,
  exposed_weather_delay AS exposed_count,
  unexposed_weather_delay AS unexposed_count,
  (exposed_weather_delay / total_flights) AS exposed_rate,
  (unexposed_weather_delay / total_flights) AS unexposed_rate,
  ((exposed_weather_delay / total_flights)/ (unexposed_weather_delay / total_flights)) AS relative_risk,
  total_flights
FROM delay_counts

UNION ALL

SELECT
  'NAS' AS motivo,
  exposed_nas_delay AS exposed_count,
  unexposed_nas_delay AS unexposed_count,
  (exposed_nas_delay / total_flights) AS exposed_rate,
  (unexposed_nas_delay / total_flights) AS unexposed_rate,
  ((exposed_nas_delay / total_flights)/ (unexposed_nas_delay / total_flights)) AS relative_risk,
  total_flights
FROM delay_counts

UNION ALL

SELECT
  'Seguridad' AS motivo,
  exposed_security_delay AS exposed_count,
  unexposed_security_delay AS unexposed_count,
  (exposed_security_delay / total_flights) AS exposed_rate,
  (unexposed_security_delay / total_flights) AS unexposed_rate,
  ((exposed_security_delay / total_flights)/ (unexposed_security_delay / total_flights)) AS relative_risk,
  total_flights
FROM delay_counts

UNION ALL

SELECT
  'Aeronave Tardía' AS motivo,
  exposed_late_aircraft_delay AS exposed_count,
  unexposed_late_aircraft_delay AS unexposed_count,
  (exposed_late_aircraft_delay / total_flights) AS exposed_rate,
  (unexposed_late_aircraft_delay / total_flights) AS unexposed_rate,
  ((exposed_late_aircraft_delay / total_flights)/ (unexposed_late_aircraft_delay / total_flights)) AS 
relative_risk,
  total_flights
FROM delay_counts;
