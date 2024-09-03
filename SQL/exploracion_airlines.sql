  -- Query para nulos en airlines
SELECT
  COUNTIF(Code IS NULL) AS null_Code,
  COUNTIF(Description IS NULL) AS null_Description
FROM
  `proyecto4-vuelos.dataset_vuelos.airline_code_dictionary` ; 
-- Query para duplicados Code - AIRLINE
SELECT
  Code,
  COUNT(*) AS count_duplicates
FROM
  `proyecto4-vuelos.dataset_vuelos.airline_code_dictionary`
GROUP BY
  Code
HAVING
  COUNT(*) > 1; 
-- Query para duplicados Description - AIRLINE
SELECT
  Description,
  COUNT(*) AS count_duplicates
FROM
  `proyecto4-vuelos.dataset_vuelos.airline_code_dictionary`
GROUP BY
  Description
HAVING
  COUNT(*) > 1;