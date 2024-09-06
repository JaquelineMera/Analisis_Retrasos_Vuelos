WITH group_expuesto AS (
    SELECT
        AIRLINE_CODE,
        COUNTIF(STATUS_VUELO = 'RETRASO') AS retrasos_expuesto,
        COUNT(*) AS total_vuelos_expuesto
    FROM
        `proyecto4-vuelos.procesos_vuelos.flights_consolidado`
    GROUP BY
        AIRLINE_CODE
),
totals AS (
    SELECT
        COUNTIF(STATUS_VUELO = 'RETRASO') AS total_retrasos,
        COUNT(*) AS total_vuelos
    FROM
        `proyecto4-vuelos.procesos_vuelos.flights_consolidado`
)
SELECT
    a.AIRLINE_CODE,
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
