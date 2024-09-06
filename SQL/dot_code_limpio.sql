-- Query para manejar nulos y duplicados dot
SELECT
  *
FROM (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY Code ORDER BY Code) AS row_num
  FROM
    `proyecto4-vuelos.dataset_vuelos.dot_code_dictionary`
  WHERE
    Description IS NOT NULL
)
WHERE
  row_num = 1
ORDER BY Code ASC
;