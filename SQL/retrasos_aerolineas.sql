---Aerolineas---
---Aerolineas con más retrasos y su promedio de tiempo (en min)---
SELECT
  AIRLINE_CODE,
  DESCRIPTION_AIRLINE,
  COUNT(*) AS total_retrasos,
  ROUND(AVG(TOTAL_DELAY) ,2)AS promedio_retraso
FROM
  `proyecto4-vuelos.procesos_vuelos.flights_consolidado`
WHERE
 TOTAL_DELAY > 0  -- Filtramos solo los retrasos (TOTAL_DELAY > 0)
GROUP BY
  AIRLINE_CODE,
  DESCRIPTION_AIRLINE
ORDER BY
  total_retrasos DESC;