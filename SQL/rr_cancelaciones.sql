-- 1. Contar el total de vuelos cancelados
WITH total_cancelled AS (
  SELECT
    COUNT(*) AS total_cancelled
  FROM
    `proyecto4-vuelos.procesos_vuelos.cancelaciones_limpia`
),

-- 2. Contar las cancelaciones por motivo (Total cancelados expuesto)
cancelled_by_reason AS (
  SELECT
    CANCELLATION_REASON,
    COUNT(*) AS reason_cancelled
  FROM
    `proyecto4-vuelos.procesos_vuelos.cancelaciones_limpia`
  GROUP BY
    CANCELLATION_REASON
),

-- 3. Calcular el total cancelados no expuesto
total_cancelled_no_exposed AS (
  SELECT
    c.CANCELLATION_REASON,
    t.total_cancelled - c.reason_cancelled AS total_no_exposed
  FROM
    cancelled_by_reason c
  CROSS JOIN
    total_cancelled t
),

-- 4. Calcular las tasas de cancelación (Tasa expuesto y Tasa no expuesto)
cancelled_rates AS (
  SELECT
    c.CANCELLATION_REASON,
    c.reason_cancelled AS total_cancelled_exposed,
    t.total_cancelled - c.reason_cancelled AS total_cancelled_no_exposed,
    t.total_cancelled AS total_cancelled,
    (c.reason_cancelled * 1.0) / t.total_cancelled AS tasa_expuesto,
    ((t.total_cancelled - c.reason_cancelled) * 1.0) / t.total_cancelled AS tasa_no_expuesto
  FROM
    cancelled_by_reason c
  CROSS JOIN
    total_cancelled t
),

-- 5. Calcular el riesgo relativo
final_result AS (
  SELECT
    CANCELLATION_REASON,
    total_cancelled_exposed,
    total_cancelled_no_exposed,
    total_cancelled,
    tasa_expuesto,
    tasa_no_expuesto,
    tasa_expuesto / tasa_no_expuesto AS riesgo_relativo
  FROM
    cancelled_rates
)

-- 6. Seleccionar las columnas finales
SELECT
  CANCELLATION_REASON,
  total_cancelled_exposed,
  total_cancelled_no_exposed,
  total_cancelled,
  tasa_expuesto,
  tasa_no_expuesto,
  riesgo_relativo
FROM
  final_result
ORDER BY
  riesgo_relativo DESC;