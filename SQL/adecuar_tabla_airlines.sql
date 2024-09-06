--Query para reemplazar los encabezados de la tabla 
-- y quitar el renglón de encabezado 
CREATE OR REPLACE TABLE `proyecto4-vuelos.dataset_vuelos.airline_code_dictionary` AS
SELECT 
  string_field_0 AS Code,
  string_field_1 AS Description
FROM `proyecto4-vuelos.dataset_vuelos.airline_code_dictionary`
WHERE string_field_0 != 'Code';