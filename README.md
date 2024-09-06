# Laboratoria: Análisis de retrasos y cancelaciones.
Análisis de retrasos y cancelaciones en vuelos de EUA en enero 2023.
![Untitled design](https://github.com/user-attachments/assets/45e10068-7a75-4be5-8733-2ef380a66616)

# 📊 Temas 
- [Objetivo](#objetivo)
- [Equipo](#equipo)
- [Herramientas](#herramientas)
- [Lenguajes](#lenguajes)
- [Procesamiento y análisis](#procesamiento-y-análisis)
  - [Procesamiento de los datos](#procesamiento-de-los-datos)
  - [Análisis exploratorio](#análisis-exploratorio)
  - [Cálculo de riesgo relativo](#cálculo-de-riesgo-relativo)
  - [Validación de hipótesis](#validación-de-hipótesis)
- [Resultados](#resultados)
- [Conclusiones](#conclusiones)
- [Recomendaciones](#recomendaciones)
- [Pasos a seguir](#pasos-a-seguir)
- [Enlaces](#enlaces)

## Objetivo
Evaluar y caracterizar los patrones de retraso y cancelaciones en los vuelos de Estados Unidos durante enero de 2023, con el fin de identificar rutas, aeropuertos, aerolíneas y factores específicos que contribuyen significativamente a estos retrasos, utilizando técnicas de análisis estadístico.

## Equipo
- [Jaqueline Mera](https://github.com/JaquelineMera)

## Herramientas
+ BigQuery
+ Google Colab
+ Power BI

## Lenguajes
+ SQL
+ Python

# Procesamiento y análisis

## Procesamiento de los datos
El flujo de trabajo incluyó varias etapas: el procesamiento de los datos, análisis exploratorio, el cálculo de riesgo relativo y la validación de hipótesis.

- Conectar/importar datos a otras herramientas:
  - Se han importado los datos en tablas dentro del ambiente de BigQuery (DOT_CODE_DICTIONARY, AIRLINE_CODE_DICTIONARY y flights_202301).
  
- Identificar y manejar valores nulos:
  - Se identificaron valores nulos a través de comandos SQL `COUNTIF` y `IS NULL`. No son registros faltantes, sino valores no aplicables para vuelos cancelados o desviados. La excepción fue `CRS_ELAPSED_TIME` que presentó un nulo verdadero.
    - Nulos en tabla `flights_202301`:
      - `null_DEP_TIME`: 9,978
      - `null_DEP_DELAY`: 9,982
      - `null_TAXI_OUT`: 10,197
      - `null_WHEELS_OFF`: 10,197
      - `null_WHEELS_ON`: 10,519
      - `null_TAXI_IN`: 10,519
      - `null_ARR_TIME`: 10,519
      - `null_ARR_DELAY`: 11,640
      - `null_CRS_ELAPSED_TIME`: 1
      - `null_ELAPSED_TIME`: 11,640
      - `null_AIR_TIME`: 11,640
      - `null_DELAY_DUE_CARRIER`: 422,124
      - `null_DELAY_DUE_WEATHER`: 422,124
      - `null_DELAY_DUE_NAS`: 422,124
      - `null_DELAY_DUE_SECURITY`: 422,124
      - `null_DELAY_DUE_LATE_AIRCRAFT`: 422,124
    - Nulos en tabla `airline_code_dictionary`:
      - `null_Description`: 4
  - Se manejaron valores nulos con imputación simple de 0, excepto el único nulo en `CRS_ELAPSED_TIME`, que se eliminó de la tabla con `WHERE CRS_ELAPSED_TIME IS NOT NULL`.

- Identificar y manejar valores duplicados:
  - Se identificaron duplicados en la tabla `dot_code_dictionary`: 4 duplicados.
  - Se manejaron creando un número de fila (`ROW_NUMBER`), manteniendo solo un registro para evitar duplicados.

- Identificar y manejar datos discrepantes en variables categóricas:
  - Se encontraron registros con diferente formato en `DOT_CODE_DICTIONARY`, los cuales se eliminaron al manejar los duplicados.

- Identificar y manejar datos discrepantes en variables numéricas:
  - Se identificaron outliers mediante histogramas y boxplots en Google Colab. Se decidió no eliminarlos.

- Comprobar y cambiar tipo de dato:
  - Se cambió el tipo de dato de las columnas `CRSDEPTIME`, `DEP_TIME`, `WHEELS_OFF`, `WHEELS_ON`, `CRSARRTIME`, `ARR_TIME` de entero a `TIME`.

- Crear nuevas variables:
  - La creación de variables fue iterativa durante el proyecto. Se crearon:
    - `DAY_OF_WEEK`: Día de la semana con `FORMAT_DATE`.
    - `ROUTE_CITY`: Ruta ciudad a ciudad a partir de `ORIGIN_CITY` y `DEST_CITY`.
    - `ROUTE_AIRPORT`: Ruta aeropuerto a aeropuerto con `ORIGIN` y `DEST`.
    - `HOUR_CRS_DEP_T`: Hora del día con `EXTRACT` y `TIME`.
    - `DISTANCE_QUARTILE`: Cuartil de la distancia con `NTILE(4)`.
    - `TOTAL_DELAY`: Suma de los 5 motivos de retraso.
    - `TOTAL_NUM_DELAY`: 1 si hubo retraso, 0 si no.
    - `STATUS_VUELO`: Estado del vuelo (`A TIEMPO`, `RETRASO`, `DESVIADO`, `CANCELADO`).
    - `STATUS_VUELO_DES`: Descripción detallada de `STATUS_VUELO`.
    - `EXCLUDING_CARRIER`: Grupo no expuesto para `Carrier`.
    - `EXCLUDING_WEATHER`: Grupo no expuesto para `Weather`.
    - `EXCLUDING_NAS`: Grupo no expuesto para `NAS`.
    - `EXCLUDING_SECURITY`: Grupo no expuesto para `Security`.
    - `EXCLUDING_LATE_AIRCRAFT`: Grupo no expuesto para `Late Aircraft`.

- Unir tablas:
  - Se realizaron uniones (`LEFT JOIN`) entre las tablas `flights_cambio_time`, `airline_code_dictionary` y `dot_code_limpio`.

- Construir tablas auxiliares:
  - Se crearon tablas para observar aerolíneas, aeropuertos y rutas con más retrasos y tiempos de cancelaciones.
    - `retrasos_aerolineas`
    - `top_10_retrasos_aeropuertos`
    - `top_10_retrasos_ruta`
    - `cancelaciones_limpia`

## Análisis exploratorio
El análisis exploratorio se llevó a cabo en Power BI, cargando el consolidado desde BigQuery.

- Agrupar y visualizar datos según variables categóricas:
  - Se agruparon retrasos y cancelaciones por aerolíneas, aeropuertos, rutas y motivos.
  
- Aplicar medidas de tendencia central y dispersión:
  - Se calcularon medidas de tendencia central (media, mediana) y dispersión (mínimo, máximo, desviación estándar) para los retrasos.

- Visualizar el comportamiento de los datos a lo largo del tiempo:
  - Se observó el comportamiento de los retrasos y cancelaciones durante el mes de enero, así como el promedio de minutos de retraso por hora del día.

- Calcular cuartiles:
  - Se calcularon cuartiles para la variable `DISTANCE`.

- Calcular correlación entre variables:
  - Se realizó una matriz de correlación en Google Colab.

## Cálculo de riesgo relativo

Se ha calculado el riesgo relativo utilizando los comandos `WITH`, `COUNT`, `COUNTIF`, `CASE`, `WHEN`, `MIN`, y `MAX` en BigQuery para los retrasos. La muestra se segmentó a partir de aerolíneas, aeropuertos, rutas, motivos y horas. Además, se hizo una segmentación por cuartiles para la distancia. Por último, se calculó el riesgo relativo para cancelaciones por motivo.

De acuerdo al Departamento de Transporte de los Estados Unidos (DOT) y la Administración Federal de Aviación (FAA), se considera retraso cuando hay una demora de 15 minutos o más.

El riesgo relativo se define como:

**Riesgo Relativo (RR)** = \[Tasa de Incidencia en el Grupo Expuesto\] / \[Tasa de Incidencia en el Grupo No Expuesto\]

# Validación de hipótesis

Se validaron 6 hipótesis a través del cálculo del riesgo relativo y los resultados del análisis exploratorio de datos. Las hipótesis son:

- **Hipótesis 1:** Algunas aerolíneas tienen un historial de retrasos significativamente mayor que otras.
- **Hipótesis 2:** Algunos aeropuertos tienden a tener retrasos más frecuentes o severos en comparación con otros.
- **Hipótesis 3:** Los vuelos más largos tienen mayores tiempos de retraso en comparación con los vuelos más cortos.
- **Hipótesis 4:** Los retrasos en los vuelos son más comunes durante las horas punta del día.
- **Hipótesis 5:** Algunos motivos de retrasos son más prevalentes que otros, indicando causas específicas más comunes para el retraso de un vuelo.
- **Hipótesis 6:** Algunos códigos de cancelación son más prevalentes que otros, indicando causas específicas más comunes.

# Resultados
- **EDA:** Del Análisis Exploratorio de Datos (EDA) podemos decir que se estudiaron un total de 538 mil vuelos, operando en 339 aeropuertos y cubriendo 5,581 rutas, bajo la operación de 15 aerolíneas. Del total de vuelos, 117,000 (21.66%) experimentaron algún tipo de retraso, lo que significa que aproximadamente 1 de cada 5 vuelos se vio afectado. Además, 10,000 vuelos fueron cancelados, representando casi el 2%. Cabe destacar que el 11 de enero ocurrió una interrupción significativa del sistema de la FAA (Administración Federal de Aviación), afectando las operaciones aéreas en todo el país.

- **Hipótesis 1:** Algunas aerolíneas tienen un historial de retrasos significativamente mayor que otras.
  - La hipótesis se valida parcialmente. Cuatro de las 15 aerolíneas presentan un riesgo relativo alto (entre 1.22 y 1.59), lo que indica que algunas aerolíneas tienen mayor riesgo de retrasos. Sin embargo, las aerolíneas con más retrasos no siempre tienen los riesgos relativos más altos, ya que estas se encuentran por debajo de 1.03.

- **Hipótesis 2:** Algunos aeropuertos tienden a tener retrasos más frecuentes o severos en comparación con otros.
  - Se valida. Hay aeropuertos que presentan un riesgo relativo elevado (64 aeropuertos con riesgo entre 1.2 y 2.5), con PPG Pago Pago TT y CKB Clarksburg/Fairmont, WV, superando el riesgo relativo de 2. Sin embargo, los aeropuertos con más riesgo relativo tienden a ser aeropuertos pequeños con menos vuelos.

- **Hipótesis 3:** Los vuelos más largos tienen mayores tiempos de retraso en comparación con los vuelos más cortos.
  - Se valida. Los vuelos más largos, entre 1.1 mil y 5.1 mil millas, tienen un riesgo relativo mayor (1.11), mientras que los vuelos más cortos tienen un menor riesgo relativo (0.88 para vuelos de hasta 0.4 mil millas).

- **Hipótesis 4:** Los retrasos en los vuelos son más comunes durante las horas punta del día.
  - Se valida parcialmente. Si bien se registra un mayor número de retrasos a las 6:00 am y entre las 6:00 y 7:00 pm, el mayor riesgo relativo no ocurre en estas horas punta. El mayor riesgo relativo de retrasos (1.98-2.04) se presenta entre las 3:00 y 4:30 am, un periodo que no coincide con las horas de mayor tráfico aéreo. La hipótesis se valida en términos de magnitud de retrasos, pero no en relación con el mayor riesgo relativo.

- **Hipótesis 5:** Algunos motivos de retrasos son más prevalentes que otros, indicando causas específicas más comunes para el retraso de un vuelo.
  - Se valida. Los retrasos por operador (1.18) y por NAS (1.05) son más comunes, con poco más de 20 mil retrasos cada uno. Como tercer motivo se encuentran los retrasos por aeronaves tardías (0.86) con 15 mil retrasos. Por último, los retrasos por clima tienen un riesgo relativo bajo (0.06), al igual que los de seguridad (0.01). Cabe destacar que el 47% de los retrasos son multicausales.

- **Hipótesis 6:** Algunos códigos de cancelación son más prevalentes que otros, indicando causas específicas más comunes.
  - Se valida. Las cancelaciones debidas al clima presentan el mayor riesgo relativo (1.8), con 6.6 mil cancelaciones. En comparación, las cancelaciones por seguridad y operador tienen riesgos relativos significativamente más bajos.

# Conclusiones

- **Variabilidad en el riesgo de retrasos entre aerolíneas:** No todas las aerolíneas presentan el mismo riesgo de retrasos, y las aerolíneas con más retrasos no siempre tienen los mayores riesgos relativos. Esto sugiere que la capacidad para gestionar las operaciones es crucial para mantener bajo control los retrasos.
  
- **Diferencias notables entre aeropuertos:** Aunque muchos aeropuertos tienen un riesgo relativo de retraso alto, estos no necesariamente coinciden con los que operan más vuelos. Los aeropuertos pequeños, aunque menos concurridos, parecen enfrentarse a mayores desafíos en la gestión de operaciones.
  
- **Mayor probabilidad de retrasos en vuelos largos:** Los vuelos más largos tienen un riesgo más elevado de sufrir retrasos debido a la complejidad logística, las múltiples escalas y la exposición prolongada a factores externos.
  
- **Horarios pico son propensos a retrasos en cuanto a su frecuencia:** Las horas pico, especialmente las mañanas y tardes, tienen una mayor propensión a retrasos debido a la alta demanda y congestión operativa.
  
- **Primeras horas de la mañana tienen más riesgo:** La posibilidad de sufrir retrasos en la madrugada puede deberse a la acumulación de problemas operativos del día anterior.
  
- **Anomalías en el Operador y el sistema NAS son los principales motivos de retrasos:** Esto puede atribuirse al mantenimiento, la tripulación y la gestión operativa de la aerolínea, así como complicaciones en el tráfico aéreo. Otros factores, como el clima o la seguridad, tienen un impacto relativamente menor, aunque estos deben ser considerados.
  
- **Cancelaciones mayoritariamente asociadas al clima:** Las cancelaciones por condiciones climáticas adversas son las más comunes entre los códigos de cancelación, superando ampliamente a otros motivos como problemas del operador o seguridad.

# Recomendaciones

- **Optimización de las operaciones aéreas:** Las aerolíneas y aeropuertos con mayor riesgo relativo deberían optimizar sus operaciones, mejorando la planificación, la gestión del personal y la asignación de recursos durante los períodos de mayor demanda.
  
- **Gestión de aeropuertos pequeños:** Dado que los aeropuertos más pequeños enfrentan un riesgo mayor de retrasos, es esencial que estos inviertan en mejorar su infraestructura operativa, como sistemas de gestión de tráfico aéreo y control en tierra.
  
- **Planificación en vuelos largos:** Optimizar las conexiones y prever potenciales problemas durante las rutas largas puede reducir las demoras.
  
- **Estrategias para mitigar retrasos en horas pico:** Las aerolíneas y los aeropuertos deben evaluar la programación de vuelos durante las horas pico. Se recomienda redistribuir los vuelos en horarios menos congestionados o aumentar la capacidad operativa durante estos períodos. Una mejor gestión del tráfico aéreo en las primeras horas del día y las tardes podría aliviar los retrasos.
  
- **Enfocar esfuerzos en causas operacionales:** La implementación de herramientas que permitan una respuesta más rápida y efectiva ante problemas operativos podría reducir significativamente los retrasos.
  
- **Preparación ante condiciones climáticas:** Mejorar la capacidad de reacción en situaciones climáticas severas, así como proporcionar flexibilidad a los pasajeros, podría reducir las cancelaciones y mejorar la experiencia del usuario.
  
- **Análisis continuo y adaptación:** Es crucial que las aerolíneas y los aeropuertos realicen un análisis continuo de sus operaciones, evaluando los cambios en el riesgo de retrasos y cancelaciones. Adaptar sus estrategias con base en datos actualizados permitirá a las empresas mantener una mejor competitividad y ofrecer un servicio más eficiente.

# Pasos a seguir

- **Modelo de tiempo de retraso:** Desarrollar un modelo predictivo para estimar el tiempo de retraso de vuelos en función de variables como el aeropuerto de origen, la distancia del vuelo y el tiempo de taxi. El modelo utilizará regresión lineal, asumiendo una relación lineal entre las variables independientes y el tiempo de retraso, con homocedasticidad e independencia de los errores. Para evaluar su rendimiento, se emplearán métricas como el coeficiente de determinación (R²), el error cuadrático medio (MSE) y el error absoluto medio (MAE).

- **Modelo predictivo de retrasos:** Desarrollar un modelo para predecir si un vuelo se retrasará o no, utilizando variables categóricas binarias. La variable dependiente será binaria (RETRASO), tomando el valor 1 si el retraso supera un umbral específico (ej. 15 minutos) y 0 si no lo hace. Las variables independientes incluirán factores como la distancia del vuelo, retrasos debidos a la aerolínea, el clima, el control del tráfico aéreo, la seguridad y el horario de salida programado, entre otros. Este modelo utilizará técnicas de clasificación para anticipar la probabilidad de que un vuelo se retrase.






