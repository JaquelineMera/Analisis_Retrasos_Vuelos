SELECT 
    fc.*,
    -- Desde la tabla rr_delays
    rd1.relative_risk AS relative_risk_carrier,
    rd2.relative_risk AS relative_risk_weather,
    rd3.relative_risk AS relative_risk_nas,
    rd4.relative_risk AS relative_risk_security,
    rd5.relative_risk AS relative_risk_late_aircraft,
    -- Desde la tabla rr_aerolineas
    ra.Riesgo_Relativo AS relative_risk_airline,
    -- Desde la tabla rr_aeropuertos
    rp.Riesgo_Relativo AS relative_risk_origin_airport,
    -- Desde la tabla rr_route
    rr.Riesgo_Relativo AS relative_risk_route,
    -- Desde la tabla rr_hora
    rh.relative_risk AS relative_risk_hour,
    -- Desde la tabla rr_distancia
    rrd.riesgo_relativo AS relative_risk_distance,
    -- Nueva columna desde rr_cancelaciones
    rrq.riesgo_relativo AS relative_risk_cancellation

FROM 
    `proyecto4-vuelos.procesos_vuelos.flights_consolidado` fc
-- Uniones con rr_delays basado en motivo
LEFT JOIN `proyecto4-vuelos.procesos_vuelos.rr_delays` rd1
    ON fc.DELAY_DUE_CARRIER > 0 AND rd1.motivo = 'Operador'
LEFT JOIN `proyecto4-vuelos.procesos_vuelos.rr_delays` rd2
    ON fc.DELAY_DUE_WEATHER > 0 AND rd2.motivo = 'Clima'
LEFT JOIN `proyecto4-vuelos.procesos_vuelos.rr_delays` rd3
    ON fc.DELAY_DUE_NAS > 0 AND rd3.motivo = 'NAS'
LEFT JOIN `proyecto4-vuelos.procesos_vuelos.rr_delays` rd4
    ON fc.DELAY_DUE_SECURITY > 0 AND rd4.motivo = 'Seguridad'
LEFT JOIN `proyecto4-vuelos.procesos_vuelos.rr_delays` rd5
    ON fc.DELAY_DUE_LATE_AIRCRAFT > 0 AND rd5.motivo = 'Aeronave Tardía'
-- Unión con rr_aerolineas basado en AIRLINE_CODE
LEFT JOIN `proyecto4-vuelos.procesos_vuelos.rr_aerolineas` ra
    ON fc.AIRLINE_CODE = ra.AIRLINE_CODE
-- Unión con rr_aeropuertos basado en ORIGIN
LEFT JOIN `proyecto4-vuelos.procesos_vuelos.rr_aeropuertos` rp
    ON fc.ORIGIN = rp.ORIGIN
-- Unión con rr_route basado en ROUTE_AIRPORT
LEFT JOIN `proyecto4-vuelos.procesos_vuelos.rr_route` rr
    ON fc.ROUTE_AIRPORT = rr.ROUTE_AIRPORT
-- Unión con rr_hora basado en hour_crs_dep_t
LEFT JOIN `proyecto4-vuelos.procesos_vuelos.rr_hora` rh
    ON fc.HOUR_CRS_DEP_T = rh.HOUR_CRS_DEP_T
-- Unión con rr_distancia basado en num_quartile y DISTANCE_QUARTILE
LEFT JOIN `proyecto4-vuelos.procesos_vuelos.rr_distancia` rrd
    ON fc.DISTANCE_QUARTILE = rrd.num_quartile
-- Nueva unión con rr_cancelaciones basado en el código de cancelación
LEFT JOIN `proyecto4-vuelos.procesos_vuelos.rr_cancelaciones` rrq
    ON CASE
           WHEN fc.CANCELLATION_CODE = 'A' THEN rrq.CANCELLATION_REASON = 'Carrier'
           WHEN fc.CANCELLATION_CODE = 'B' THEN rrq.CANCELLATION_REASON = 'Weather'
           WHEN fc.CANCELLATION_CODE = 'C' THEN rrq.CANCELLATION_REASON = 'National Aviation System'
           WHEN fc.CANCELLATION_CODE = 'D' THEN rrq.CANCELLATION_REASON = 'Security'
           ELSE FALSE
       END
