# Laboratoria: Análisis de retrasos y cancelaciones.
Análisis de retrasos y cancelaciones en vuelos de EUA en enero 2023.
![Untitled design](https://github.com/user-attachments/assets/45e10068-7a75-4be5-8733-2ef380a66616)

# 📊Temas 
- [Objetivo](#objetivo)
- [Equipo](#equipo)
- [Herramientas](#herramientas)
- [Lenguajes](#lenguajes)
- [Procesamiento y análisis](#procesamiento-y-análisis)
  - [Procesamiento de los datos](#procesamiento-de-los-datos)
  - [Análisis exploratorio](#análisis-exploratorio)
  - [Segmentación de variables](#segmentación-de-variables)
  - [Cálculo de riesgo relativo](#cálculo-de-riesgo-relativo)
  - [Validación de hipótesis](#validación-de-hipótesis)
  - [Creación del modelo](#creación-del-modelo)
- [Resultados](#resultados)
- [Conclusiones](#conclusiones)
- [Recomendaciones](#recomendaciones)
- [Enlaces](#enlaces)

## Objetivo
Evaluar y caracterizar los patrones de retraso y cancelaciones en los vuelos de Estados Unidos durante enero de 2023, con el fin de identificar rutas, aeropuertos, aerolíneas y factores específicos que contribuyen significativamente a estos retrasos, utilizando técnicas de análisis estadístico.

## Equipo
- [Jaqueline Mera](https://github.com/JaquelineMera)
## Herramientas
+ BigQuery
+ Google Colab
+ Looker Studio

## Lenguajes
+ SQL
+ Python

## Procesamiento y análisis
El flujo de trabajo incluyó varias etapas, el procesamiento de los datos, análisis exploratorio, segmetación de variables, cálculo de riesgo relativo, validación de hipótesis, creación de variables dummies, cálculo de score crediticio, clasificación de cliente, validación de modelo.

## Procesamiento de los datos
+ **Conectar/importar datos a BigQuery.**
  + Se han importado los datos en tablas dentro del ambiente de BigQuery (user_info, loans_outstanding, loans_details y default).
  + Se conectaron de forma paralela los datos a Google Colab. 
+ **Identificar valores nulos a través IS NULL.**
  + Se identificaron los nulos solo en: last_month_salary (7199), number_dependents (943).
+ **Imputación simple de nulos a través de IFNULL, CASE, WHEN y ELSE.**
  + Se hizo una imputación simple.
    + last_month_salary, se observó su distribución por histograma y boxplot en Google Colab, además se calculó la moda por flag 0 y 1, por lo que resultó 2,500 para flag 1 y 5,000 flag 0.
    + number_dependents, se observó su distribución por histograma y boxplot en Google Colab, además se calculó la moda por flag 0 y 1, por lo que resultó 0 para ambas flags.
      + La moda se cálculo sin outliers. 
+ **Identificar duplicados a través de COUNT, GROUP BY, HAVING.**
  + Se han buscado valores duplicados utilizando comandos SQL, para las variables user_id y loan_id, considerando son las únicas variables que no deberían duplicarse a lo largo de los registros. No se encontraron duplicados.
    + Solo la tabla loans_outstanding cuenta con la duplicación de user_id, sin embargo, esto no significa sea un error, solo es la estructura de la tabla, ya que contiene todos los préstamos. 
+ **Identificar y manejar datos fuera del alcance del análisis a través de EXCEPT, CORR, STDDEV.**
  + Se elimino la variable "sex", puesto que el género no es una variable permitida en los modelos de crédito.
  + Se hicieron correlaciones para observar la relación estadística entre las variables de la base de datos.
    + *Correlación en BigQuery*:
      + Correlación de retrasos entre 30-59/ retrasos entre 60-89: 0.98655364549866, correlación positiva extremadamente fuerte.
      + Correlación de retrasos más de 90 días/ retrasos entre 30-59: 0.98291680661459857, correlación positiva extremadamente fuerte.
      + Correlación de retrasos más de 90 días/ retrasos entre 60-89: 0.99217552634075257, correlación positiva extremadamente fuerte.
    + *Cálculo de la desviación estándar*:
      + stddev_number_times_30_59_days: 4.144020438225871
      + stddev_number_times_60_89_days: 4.1055147551019706
      + stddev_more_90: 4.12136466842672
    + La alta correlación entre dos variables indica que se debe elegir solo una variable para el análisis (modelo). La redundancia en la información de cada variable puede ser indicativo de multicolinealidad.
+ **Identificar y manejar datos inconsistentes en variables categóricas a través de SELECT DISTINCT y LOWER.**
  + Se ha identificado variaciones en las categorías loan_type, a partir de un SELECT DISTINCT.
  + Se han estandarizado la variable loan_type, han quedado homologadas las categorías “real estate” y “others”, utilizando comandos SQL como LOWER.
+ **Identificar y manejar datos inconsistentes en variables numéricas.**
  + Identificación de outliers:
    + Inicialmente, se utilizó el Z-score y el Rango intercuartílico (IQR), sin embargo, al observar el número de casos (+) que se identificaron como outliers. Se decidio hacer una inspección visual de la distribución.
    + Inspección visual de outliers, a partir de Google Colab se construyeron histogramas y boxplots para identificar valores fuera de rango. Este paso se hizo para cada variable. Se puede observar en el [Jupyter Notebook](/Jupyter_Notebook/README.md), en el apartado *Exploración de datos*. 
  + Manejo de outliers:
  + *Tabla user_info:*
    + age: Se quitaron los usuarios mayores a 96 años.
    + last_month_salary: Se quitaron los salarios mayores a 400 mil.
    + number_dependents: Tiene outliers, sin embargo, se quedan por la mínima cantidad de casos. 
  + *Tabla loan_detail:*
    + more_90_days_overdue: Se quitaron los valores de 96 y 98 veces de retrasos.
    + number_times_delayed_payment_loan_30_59_days: Se quitaron los valores de 96 y 98 veces de retrasos.
    + number_times_delayed_payment_loan_60_89_days: Se quitaron los valores de 96 y 98 veces de retrasos.
    + using_lines_not_secured_personal_assets: Tiene outliers, sin embargo, se quedan por ser información crítica.
    + debt_ratio: Tiene outliers, sin embargo, se quedan por ser información crítica.
+ *Tablas loan outstanding y default:*
    + No tienen outliers.
+ **Crear nuevas variables:**
  + birth_year: Se cálculo el año de nacimiento a partir de la edad del usuario, a través de EXTRACT y CURRENT_DATE.
  + generational_group: Se cálculo el grupo generacional a partir de año de nacimiento, a través de CASE y WHEN. Los grupos son: Alpha (>2011), Zeta (1994-2010), Millenials (1981-1993), Generación X (1969-1980), Baby Boomers <1969.
  + debt_ratio_s: Se segmento esta variable con CASE y WHEN, a partir de, 0 = Sin uso, <0.40 Bajo, >=40 - <= 0.60 Medio, >=60 - <= 1 Alto, >1 Extraordinario. Estás categorías después tomaron un valor númerico de segmento (similar al del cuartil), para esta variable hubo 5 segmentos de 0 al 4.
  + using_lines_s: Se segmento esta variable con CASE y WHEN, a partir de, 0 = Sin uso, <0.40 Bajo, >=40 - <= 0.60 Medio, >=60 - <= 1 Alto, >1 Extraordinario. Estás categorías después tomaron un valor númerico de segmento (similar al del cuartil), para esta variable hubo 5 segmentos de 0 al 4. 
  + more_90_days_s: Se segmento esta variable con CASE y WHEN, a partir de, 0 = Sin retrasos, >=1 - <= 5 Bajo, >=5 - <= 10 Moderados, >10 Muchos. Estás categorías después tomaron un valor númerico de segmento (similar al del cuartil), para esta variable hubo 4 segmentos de 0 al 3.
+ **Construir tablas auxiliares:**
  + Se ha construido una tabla auxiliar del total de préstamos a partir de loans_ outstanding_limpio (sin discrepancias), contiene las variables: total_loans, total_others y total_real_estate.
+ **Unir tablas**
  + Se ha unificado el consolidado de información de 2 tablas limpias, 1 tabla auxiliar y las 2 tablas de variables nuevas. A partir de la funcionalidad del comando INNER JOIN.
    + Tablas limpias originales: user_info_flag_l y loans_detail_l.
    + Tabla auxiliar: total_loan_outstanding.
    + Tablas nuevas: generaciones y variables nuevas (variables por segmentos). 
## Análisis exploratorio
El análisis exploratorio se llevo a cabo en Looker Studio, se cargo el consolidado desde BigQuery. 
+ **Agrupar datos según variables categóricas.**
  + Se añadieron campos, un grupo por tipo de pagador (buen y mal pagador) y un campo calculado para agrupar la edad por cuartiles.
  + Se crearon tablas y scorecard para explorar los datos. 
+ **Visualizar las variables categóricas.**
  + Se crearon gráficos de barras y gráficos bivariados.
+ **Aplicar medidas de tendencia central y dispersión.**
  + Se crearon tablas con las medidas de tendencia central y dispersión por buen y mal pagador.
  + Se calculo, la media, la mediana, mínimo, máximo, y desviación estándar.
  + La exploración se hizo por: perfil de usuario, préstamos y retrasos, y por último métricas de endeudamiento (debt ratio y uso de línea de crédito). 
+ **Visualizar distribución a través de Boxplots.**
  + Se crearon campos calculados para el percentil 25 y 75, con el fin de crear boxplots.
  + Se observo la distribución de las variables por buen y mal pagador.
  + La exploración se hizo por: perfil de usuario, préstamos y retrasos, y por último métricas de endeudamiento (debt ratio y uso de línea de crédito).
+ **Calcular correlación entre las variables numéricas.**
  + Se crearon gráficos de dispersión. 
  + Se creo una matriz de correlación en Google Colab con el consolidado. Se puede observar en el [Jupyter Notebook](/Jupyter_Notebook/README.md), en el apartado *Matriz de Correlación*.

+ Nota: Para observar el Análisis exploratorio, revisar el Dashboard en los apartados **EDA**. 
## Segmentación de variables
Se calcularon los cuartiles para cada una de las variables en BigQuery a través de NTILE, OVER y ORDER BY, con el fin de calcular el riesgo relativo por segmento. Se analizaron los rangos por variable (en Looker Studio) y se decidió segmentar las variables more 90 days overdue, debt ratio, y using lines not secured de acuerdo con los segmentos creados al construir nuevas variables. Esta decisión se tomó al observar cuartiles con rangos similares debido a un alto número de valores repetidos (como "0") o valores extremadamente altos, que generaban un rango de cuartil demasiado amplio.

Se definieron 7 variables como relevantes en el análisis exploratorio. 
+ Age: Edad, se segmento por cuartiles. 
+ Debt ratio: Ratio de deuda, se segmento con los rango de la nueva variable. 
+ Last month salary: Último salario mensual, se segmento por cuartiles. 
+ More 90 days overdue: Más de 90 días de retraso, se segmento con los rango de la nueva variable. 
+ Number dependents: Número de dependientes, se segmento por cuartiles. 
+ Total loans: Total de préstamos, se segmento por cuartiles. 
+ Using lines not secured: Uso de líneas no aseguradas, se segmento con los rango de la nueva variable. 

## Cálculo de riesgo relativo
Utilizando los comandos WITH, NTILE, COUNT, MIN, MAX, CASE, WHEN, se calculó el riesgo relativo en BigQuery para las variables seleccionadas, generando una tabla que incluye, la variable, los cuartiles y/o segmento, el total de usuarios, el total de malos y buenos pagadores, el riesgo relativo y el valor mínimo y máximo de los cuartiles y/o segmento. El riesgo relativo es decisivo para crear nuestro modelo de clasificación.
+ El riesgo relativo se define como:
  + Riesgo Relativo (RR) = [Tasa de Incidencia en el Grupo Expuesto] / [Tasa de Incidencia en el Grupo No Expuesto]

## Validación de hipótesis
Se validaron 3 hipótesis planteadas por Super Caja.
Se validaron a través del riesgo relativo por segmento. Las hipótesis son:
+ Hipótesis 1: Los más jóvenes tienen un mayor riesgo de impago. Se valida. 
+ Hipótesis 2: Las personas con más cantidad de préstamos activos tienen mayor riesgo de ser malos pagadores. Se refuta. 
+ Hipótesis 3: Las personas que han retrasado sus pagos por más de 90 días tienen mayor riesgo de ser malos pagadores. Se valida. 
## Creación del modelo
+ Creación de variables dummies
  + Se crearon 7 variables dummies de acuerdo a las variables clave, se le asigno un valor 0 y 1. Después se les asigno un peso de 1 a 5 de 7 variables, y un peso de 2 a las variables: más de 90 días de retraso y using lines not secured por su alto riesgo relativo. 
+ Cálculo de score crediticio y clasificación
  + Se sumaron las variables dummies, el rango del score va de 0 a 9, considerando como usuarios con riesgo o malos pagadores aquellos que tienen en su suma >4. 
## Validación del modelo
  + Se hizo una matriz de confusión para validar el modelo, este proceso se llevo a cabo tanto en BigQuery como en Google Colab.
  + Se aplico la técnica de regresión lógistica, para predecir la probabilidad de que un cliente sea "buen pagador" o "mal pagador" en función de las variables clave.
# Resultados
+ **Hallazgos: EDA**
El análisis exploratorio nos muestra que:
![Riesgo_credicio_Jaqueline_Mera_page-0004_R](https://github.com/user-attachments/assets/b709a683-a1d2-4ca6-83cb-ae3ebe6a30d1)

## **Hallazgos: Validación de hipótesis**
Además de las 3 hipótesis planteadas por super caja, se proponen 4 supuestos a validar. Estos son:
+ Supuesto 1: Las personas con menor salario tienen mayor riesgo a ser malos pagadores. Se valida.
+ Supuesto 2: Las personas con mayor nivel de deuda (debt ratio) tienen mayor riesgo a ser malos pagadores. Se refuta. 
+ Supuesto 3: Las personas con al menos un dependiente económico tienen mayor riesgo de ser malos pagadores. Se valida. 
+ Supuesto 4: Las personas con una línea de crédito sobregirada tienen mayor riesgo a ser malos pagadores. Se valida. 

A continuación, se muestran las hipótesis y supuestos, con el riesgo relativo de su segmento. 
![Riesgo_credicio_Jaqueline_Mera_page-0006_R](https://github.com/user-attachments/assets/e4758bf2-33f7-4461-acd4-67eb717f4ee0)
![Riesgo_credicio_Jaqueline_Mera_page-0007_R](https://github.com/user-attachments/assets/c727555b-e175-40af-9854-caa510f6ba4b)

## **Hallazgos: Matriz de confusión**
+ **Métricas Globales del Modelo**:
  + **Accuracy (Exactitud 0.94)**: El modelo clasifica correctamente el 94% de los casos. Esto significa que, en general, es bastante preciso en distinguir entre buenos y malos pagadores.
  + **Precisión (0.99)**: De todos los casos que el modelo predice como "buenos pagadores", el 99% efectivamente lo son. Esto indica que el modelo es muy conservador al identificar buenos pagadores, con muy pocos falsos positivos.
  + **Recall (Sensibilidad 0.94)**:De todos los casos que son realmente "buenos pagadores", el modelo identifica correctamente el 94%. Esto refleja que el modelo es eficaz en capturar la mayoría de los buenos pagadores, aunque algunos se escapan.
    + **Recall Buenos pagadores (0.95)**: De todos los buenos pagadores, el modelo logra identificar correctamente al 95%. 
    + **Recall Malos pagadores (0.78)**: El modelo identifica correctamente el 78% de los "malos pagadores". Sin embargo, hay un 22% de malos pagadores aun no son detectados. Por tanto, el modelo es perfectible.
  + **F1-Score (0.97)**: Indica que el modelo tiene un buen equilibrio, siendo robusto en la clasificación.
Interpretación:

![Riesgo_credicio_Jaqueline_Mera_page-0009_R](https://github.com/user-attachments/assets/a44901d6-f5c3-4c15-bceb-3c36fef72416)

## **Hallazgos: Riesgo relativo**
 La regresión logística permitio validar las hipótesis desde un enfoque estadístico.
 A continuación, se observan dos gráficos que validan la hipótesis y el supuesto: 
 + Hipótesis 3: Las personas que han retrasado sus pagos por más de 90 días tienen mayor riesgo de ser malos pagadores. Se valida. 
 + Supuesto 3: Las personas con al menos un dependiente económico tienen mayor riesgo de ser malos pagadores. Se valida. 
![Riesgo_credicio_Jaqueline_Mera_page-0010_R](https://github.com/user-attachments/assets/f4fb5327-2d94-44ae-b200-288dc1a7c9db)

# Conclusiones
+ El modelo para la automatización del riesgo crediticio se ha implementado con éxito, incrementando la identificación de malos pagadores del 1.7% al 6.5%, lo que podría prevenir un 4.8% de incumplimientos en las cuotas de préstamo.

# Recomendaciones
+ **Monitoreo y ajustes**: Probar el modelo con nuevos clientes para monitorear su desempeño y establecer ajustes periódicos en función de los patrones emergentes en los usuarios. Esto garantizará que el modelo se mantenga preciso y relevante en la evaluación del riesgo crediticio a lo largo del tiempo.
+ **Incorporar métricas externas**: Considerar la inclusión de métricas financieras externas, como el historial crediticio en otras instituciones, dado el alto riesgo de incumplimiento cuando los usuarios ya utilizan el 100% de sus líneas de crédito.
+ **Calidad de los datos**:  Mejorar la calidad de los datos, para evitar futuros errores de clasificación. Se debe mejorar la relación entre los departamentos para la validación de los mismos. 
+ **Uso de resultados del perfil de riesgo**: Creación de estrategias de mailing para alertas y avisos de pago a usuarios. Así como, crear alertas internas para limitar líneas de crédito y préstamos a usuarios propensos a caer en riesgo. 
## Enlaces
### [Presentación](https://drive.google.com/file/d/1tw7kuj2qOrHkSzV3tpXR4WsSeQGTEJhA/view?usp=sharing)
### [Dashboard](https://lookerstudio.google.com/reporting/3afa9210-90b6-4561-90c0-b5fe9d97398b)
### [Video Loom](https://www.loom.com/share/98c3bb3d11b5482a8d2b82a24cfb3bfc?sid=72a34c50-3be6-45a5-ba55-b2844cf29a31)
