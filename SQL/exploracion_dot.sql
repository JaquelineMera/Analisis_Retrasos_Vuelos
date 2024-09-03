  -- Query para nulos en dot
SELECT
  COUNTIF(Code IS NULL) AS null_Code,
  COUNTIF(Description IS NULL) AS null_Description
FROM
  `proyecto4-vuelos.dataset_vuelos.dot_code_dictionary` ; 
-- Query para duplicados  CODE - DOT
SELECT
  Code,
  COUNT(*) AS count_duplicates
FROM
  `proyecto4-vuelos.dataset_vuelos.dot_code_dictionary`
GROUP BY
  Code
HAVING
  COUNT(*) > 1; 
-- Query para duplicados Description -DOT
SELECT
  Description,
  COUNT(*) AS count_duplicates
FROM
  `proyecto4-vuelos.dataset_vuelos.dot_code_dictionary`
GROUP BY
  Description
HAVING
  COUNT(*) > 1;