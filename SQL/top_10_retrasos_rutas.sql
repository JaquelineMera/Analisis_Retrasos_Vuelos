--- Rutas ---
----Top 10 rutas con más retrasos y su promedio de tiempo (en min)---
SELECT
  ORIGIN,
  ORIGIN_CITY,
  DEST,
  DEST_CITY,
  COUNT(*) AS total_retrasos,
  ROUND(AVG(TOTAL_DELAY) ,2)AS promedio_retraso
FROM
  `proyecto4-vuelos.procesos_vuelos.flights_consolidado`
WHERE
  TOTAL_DELAY > 0  -- Filtramos solo los retrasos (TOTAL_DELAY > 0)
GROUP BY
  ORIGIN,
  ORIGIN_CITY,
  DEST,
  DEST_CITY
ORDER BY
  total_retrasos DESC
LIMIT
  10;
