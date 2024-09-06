WITH base_data AS (
  SELECT
    hour_crs_dep_t,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN total_num_delay = 1 THEN 1 ELSE 0 END) AS num_delays
  FROM
    `proyecto4-vuelos.procesos_vuelos.flights_consolidado`
  GROUP BY
    hour_crs_dep_t
),
total_data AS (
  SELECT
    COUNT(*) AS total_flights_t,
    SUM(CASE WHEN total_num_delay = 1 THEN 1 ELSE 0 END) AS total_delays
  FROM
    `proyecto4-vuelos.procesos_vuelos.flights_consolidado`
)
SELECT
  bd.hour_crs_dep_t,
  bd.num_delays,
  bd.total_flights,
  (td.total_delays - bd.num_delays) AS total_delays_no,
  (td.total_flights_t - bd.total_flights) AS total_flights_no,
  (bd.num_delays / bd.total_flights) AS tasa_grupo_expuesto,
  ((td.total_delays - bd.num_delays)  / (td.total_flights_t - bd.total_flights)) AS tasa_grupo_no_expuesto,
  (bd.num_delays / bd.total_flights) / ((td.total_delays - bd.num_delays)  / (td.total_flights_t - bd.total_flights)) AS relative_risk
FROM
  base_data bd,
  total_data td
ORDER BY
  relative_risk DESC;