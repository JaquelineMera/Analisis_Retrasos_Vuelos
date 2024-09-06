WITH group_expuesto AS (
    SELECT
        ORIGIN,
        ORIGIN_CITY,
        COUNTIF(STATUS_VUELO = 'RETRASO') AS retrasos_expuesto,
        COUNT(*) AS total_vuelos_expuesto
    FROM
        `proyecto4-vuelos.procesos_vuelos.flights_consolidado`
    GROUP BY
        ORIGIN, ORIGIN_CITY
    HAVING
        retrasos_expuesto > 0
),
totals AS (
    SELECT
        COUNTIF(STATUS_VUELO = 'RETRASO') AS total_retrasos,
        COUNT(*) AS total_vuelos
    FROM
        `proyecto4-vuelos.procesos_vuelos.flights_consolidado`
)
SELECT
    a.ORIGIN,
    a.ORIGIN_CITY,
    a.retrasos_expuesto AS Total_Expuesto,
    a.total_vuelos_expuesto AS Total_Vuelos_Expuesto,
    (SELECT total_retrasos FROM totals) - a.retrasos_expuesto AS Total_No_Expuesto,
    (SELECT total_vuelos FROM totals) - a.total_vuelos_expuesto AS Total_Vuelos_No_Expuesto,
    (a.retrasos_expuesto / a.total_vuelos_expuesto) AS Tasa_Incidencia_Expuesto,
    ((SELECT total_retrasos FROM totals) - a.retrasos_expuesto) / ((SELECT total_vuelos FROM totals) - a.total_vuelos_expuesto) AS Tasa_Incidencia_No_Expuesto,
    (a.retrasos_expuesto / a.total_vuelos_expuesto) / (((SELECT total_retrasos FROM totals) - a.retrasos_expuesto) / ((SELECT total_vuelos FROM totals) - a.total_vuelos_expuesto)) AS Riesgo_Relativo
FROM
    group_expuesto a
ORDER BY
    Riesgo_Relativo DESC;