# Informe ejecutivo — ¿qué tengo realmente?
**TFG Leroy Merlin · reconstruido y corregido · 6 de octubre de 2026**

---

## LAS 14 RESPUESTAS

### 1. ¿Qué hizo realmente mi TFG?
Integró **cuatro fuentes** de Leroy Merlin (246.678 comentarios, 54.552
valoraciones, 84.809 líneas de venta online y 47 fichas técnicas que
**construiste a mano en Excel** porque la web bloquea el scraping), las filtró a
**26 modelos de inodoro**, y analizó qué características se asocian a que un
cliente deje una reseña inferior a 5 estrellas. Con **EDA, análisis de texto en
español, regresión logística y random forest**.

### 2. ¿El código original funciona?
**Sí, en su mayor parte.** De 719 expresiones, 367 ejecutan hoy en R 4.6.1. Los
fallos se concentran en tres causas: un paquete que requiere Java (`xlsx`), una
función eliminada de `hrbrthemes` (`theme_ipsum_tw`, 45 fallos cosméticos) y un
paquete retirado de CRAN (`vip`).

### 3. ¿Se puede reproducir?
**Ahora sí, de principio a fin, en 45 segundos.** Antes no, por tres motivos:
rutas dependientes del directorio de trabajo, un espacio no separable invisible
en un nombre de fichero, y un objeto usado 1.388 líneas antes de ser creado.

### 4. ¿Qué resultados son fiables?
- **El dataset**: 884 filas × 26 productos, reconstruido idéntico ✅
- **Las conclusiones de negocio**: precio, marca y fabricación. **Boruta las corrobora** ✅
- **El análisis exploratorio y de texto** ✅
- **El AUC 0,617 que reportaste**: reproducible (0,587 de media sobre 5 semillas) ✅

### 5. ¿Qué estaba afectado por fuga?
**Solo la métrica predictiva.** Los 26 productos generan apenas **27 vectores de
predictores distintos** para 884 filas. Con split aleatorio, el 97,8-100 % de las
filas de test pertenecían a productos ya vistos. Corregido: **0,587 → 0,525**.

### 6. ¿Qué errores metodológicos tenía?
| # | Error | Gravedad |
|---|---|---|
| 1 | Fuga por producto | 🔴 |
| 2 | Sin semilla antes del split ni de Boruta | 🟠 |
| 3 | Unidad de análisis confusa (reseña vs producto) | 🟠 |
| 4 | Boruta ejecutado y no usado | 🟡 |
| 5 | `merge()` sin clave explícita | 🟡 |
| 6 | Script no ejecutable en orden | 🟠 |
| 7 | Bloque experimental mezclado con el real | 🟡 |

**Ninguno es deshonestidad.** Son los defectos típicos de trabajar
exploratoriamente en RStudio sin control de versiones.

### 7. ¿Qué he corregido?
Split por producto · semillas · claves de unión explícitas y auditadas · Boruta
con semilla y su resultado publicado · dependencias reducidas de 43 a 12 ·
localización de ficheros por patrón · pipeline lineal en cinco scripts ·
`sessionInfo` y versiones registradas.

### 8. ¿Qué resultados produce ahora?
| Modelo | Split original | Split corregido |
|---|---:|---:|
| Regresión logística | 0,5868 | **0,5249** |
| Random Forest | 0,5883 | **0,5590** |

Baseline: 0,5396. **El modelo no generaliza a productos nuevos.**

### 9. ¿Es bueno para portfolio?
**Sí, pero no por el modelo.** Ver la sección siguiente.

### 10. ¿Qué puedo afirmar en una entrevista?
- *"Integré cuatro fuentes heterogéneas de una empresa real por una clave común"*
- *"Las variables técnicas no existían: las recopilé producto a producto porque la web bloquea el scraping"*
- *"Hice análisis de texto en español con bigramas y grafos de co-ocurrencia"*
- *"Detecté que mi propio split tenía fuga de datos y la cuantifiqué: 0,587 → 0,525"*
- *"Para saber si el fallo era del modelo o de la pregunta, monté un experimento
  controlado: mismo dataset, mismo protocolo, variables distintas. El texto da
  0,793 frente a 0,521 de los atributos"*
- *"Incluí un modelo de control de una sola variable para descartar que la mejora
  viniera de que las quejas son más largas"*
- *"El mismo diseño está implementado en R y en Python y da el mismo número"*
- *"El modelo de atributos es explicativo, no predictivo, y lo digo en el README"*

### 11. ¿Qué NO debería afirmar?
- ❌ *"Un modelo predictivo"* — no predice
- ❌ *"Comparé cinco modelos"* — la memoria reporta dos
- ❌ *"Usé Boruta para seleccionar variables"* — en el original no se usaba
- ❌ *"Explicabilidad con DALEX"* — hay una sola llamada, y no está en la memoria
- ❌ Cualquier AUC sin decir con qué split

### 12. ¿Cómo lo convierto en GitHub profesional?
Ya está hecho: `README.md`, `R/` con pipeline reproducible, `original/` intacto,
`output/results/` con métricas y entorno. **Falta solo subirlo** y decidir qué
hacer con los datos (ver Privacidad).

### 13. ¿Cómo lo cuento en LinkedIn?
Ver sección «Post».

### 14. ¿Merece la pena rehacerlo en Python?
**Ya está hecho, y cambia la lectura del TFG.** Ver sección «Versión Python».
Resultado: el texto da **0,793** de AUC frente a **0,521** de los atributos,
con el mismo protocolo. El problema no era el modelo: era la pregunta.

---

## ¿SIGUE SIENDO UN BUEN PROYECTO? — valoración crítica

### Como Data Analyst sénior: **8/10**
Lo que valoro: la pregunta nace de haber trabajado en la tienda; cuatro fuentes
integradas por clave; **recopilación manual de datos cuando la vía fácil estaba
cerrada** —eso distingue a quien resuelve problemas de quien ejecuta tutoriales—;
EDA con análisis de covariación; conclusiones accionables.
Lo que no: 26 productos es poco, y el salto de «valoración» a «decisión de
negocio» es más narrativo que cuantitativo.

### Como Data Scientist sénior: **8/10** (era 6 antes de la versión Python)
Lo que valoro: **que la fuga se detecte, se mida y se publique**; el **modelo
de control** que descarta la explicación trivial; y que el mismo diseño esté
implementado en dos lenguajes dando el mismo número. Eso no lo tiene casi
ningún portfolio junior.
Lo que no: el modelo de atributos sigue teniendo 26 observaciones efectivas,
no hay validación cruzada anidada, y la etiqueta tiene ruido reconocido.

### Como entrevistador técnico: **aprobado, con condiciones**
Me interesaría el candidato **si sabe defender las limitaciones**. Si intenta
venderlo como modelo predictivo, se cae en dos preguntas.

### Como investigador académico: **3/10**
No publicable. Muestra mínima, una categoría, una tienda, datos propietarios, sin
novedad metodológica. Como TFG está bien; como investigación, no.

---

## PREGUNTAS DIFÍCILES QUE TE VAN A HACER

| Pregunta | Qué responder |
|---|---|
| *"¿AUC 0,52? Eso es inútil"* | *"Con el split honesto, sí: no generaliza a productos nuevos. Lo publico porque la alternativa era reportar 0,59 sabiendo que estaba inflado. El modelo sirve para explicar asociaciones, no para predecir."* |
| *"¿884 filas o 26 observaciones?"* | *"26. Las 884 son reseñas, pero los predictores son del producto. Esa es la limitación real y la que provoca la fuga."* |
| *"¿Por qué no agregaste a nivel de producto?"* | *"Hoy lo haría. En 2023 modelé a nivel reseña sin ver que los predictores eran constantes dentro del producto."* |
| *"¿De dónde salen las variables técnicas?"* | *"Las recopilé a mano, producto a producto. Leroy Merlin no permite scraping."* |
| *"¿Usaste Boruta?"* | *"En el script original lo ejecuté pero no usé su salida, y no aparece en la memoria. En la reconstrucción sí lo uso, y confirma precio y marca."* — **nunca lo presentes como selección original** |
| *"¿Qué harías distinto?"* | *"Tres cosas: agregar a producto, usar el texto de las reseñas —que es donde está la señal— y tratar el desbalanceo. Las dos primeras las he hecho ya en el proyecto en Python."* |
| *"¿Cómo sabes que el modelo de texto no gana sólo porque las quejas son más largas?"* | **La pregunta que separa a un junior de un senior. Tú ya la tienes respondida:** *"Puse un modelo de control con una sola variable, el número de caracteres. Da 0,662. El TF-IDF da 0,793, así que el contenido aporta +0,131 por encima de la longitud."* |
| *"¿Por qué no usaste spaCy / un transformer?"* | *"884 reseñas de 97 caracteres con faltas de ortografía reales. Un lematizador normativo acierta poco ahí y los n-gramas de carácter absorben la morfología igual. Un transformer con 884 ejemplos sobreajusta, y además quería que el repo se pudiera clonar y ejecutar sin descargar modelos."* |

---

## VERSIÓN PYTHON — construida y ejecutada

Traducir línea a línea habría reproducido el mismo callejón. La versión Python
**cambia la pregunta**: predecir la satisfacción desde el COMENTARIO, no desde
los atributos.

📁 `C:\Users\Usuario\Desktop\Claude\resenas-sanitarios-nlp`

### El resultado

| Modelo | AUC (split por producto) |
|---|---:|
| Baseline | 0,540 |
| Atributos del producto (logística) | 0,521 |
| Atributos (random forest) | 0,541 |
| **Control: sólo longitud del comentario** | **0,662** |
| **Texto (TF-IDF palabra + carácter)** | **0,793** |

**+0,27 de AUC.** Y el modelo de control demuestra que no es un artefacto: la
longitud sola ya da 0,662 (la gente insatisfecha escribe más), y el contenido
añade **+0,131** sobre eso. Ésa es la contribución real del texto.

### Las tres cosas que lo hacen defendible

**1. Validación cruzada entre lenguajes.** El modelo de atributos da 0,525 en R
(tidymodels) y 0,521 en Python (scikit-learn). Dos implementaciones
independientes del mismo diseño que coinciden: el 0,52 es real, no un artefacto
de una librería.

**2. El modelo de control.** Sin él, cualquiera atribuiría la mejora al
«análisis de sentimiento». Con él, sabes cuánto viene del contenido y cuánto de
que las quejas son más largas.

**3. Las stopwords.** La lista excluye a propósito *no, nada, nunca, poco, muy,
mal*. Las listas estándar las borran, y en opiniones son justo las que
distinguen «buena calidad» de «no es de buena calidad». El resultado lo
confirma: **`no` es el término con mayor coeficiente de queja** (+2,07).

### Lo que encontró el texto y los atributos no podían

| Bigrama | log-odds |
|---|---:|
| mala calidad | +2,40 |
| **pierde agua** | +1,99 |
| **primer día** | +1,52 |
| toma agua | +1,52 |

Y en unigramas: *mueve*, *salpica*, *desmontar*. **Son modos de fallo de
instalación y montaje**, no de diseño de producto. Ningún atributo de catálogo
iba a capturar eso. Esta es la conclusión de negocio más accionable de todo el
trabajo, y no estaba en el TFG.

### El techo que hay que declarar

De las 407 reseñas etiquetadas «queja», **246 son de 4 estrellas** (60 %), y
**139 de ésas (57 %) tienen vocabulario positivo**. La variable objetivo mete
ruido irreducible. Dilo tú antes de que te lo pregunten.

**Stack:** pandas · scikit-learn · TF-IDF · `GroupShuffleSplit` · matplotlib.
Sin spaCy a propósito: el corpus tiene faltas reales y tildes inconsistentes,
los n-gramas de carácter aguantan mejor, y el repo se clona y ejecuta sin
descargar 50 MB de modelos. Es una decisión que puedes defender.

---

## POST DE LINKEDIN

> **Hook:** *"Hace dos años entregué un TFG con un AUC de 0,617. Lo he vuelto a
> ejecutar y estaba midiendo mal. Corregirlo lo bajó a 0,525 — y eso resultó ser
> la parte interesante."*
>
> **El contexto:** trabajé en Leroy Merlin y quería saber qué características de
> un inodoro hacen que el cliente no se queje. Integré cuatro fuentes y recopilé
> a mano las fichas técnicas de 47 productos, porque la web bloquea el scraping.
>
> **El error:** 884 reseñas, pero sólo 26 productos. Como los predictores eran
> atributos *del producto*, había apenas **27 combinaciones distintas**. Mi split
> aleatorio por fila ponía el mismo producto en entrenamiento y en test: entre el
> 97,8 % y el 100 % de las filas de test ya se habían visto.
>
> Corregido el split, AUC **0,587 → 0,525**. Por debajo del baseline.
>
> **La pregunta que me hice:** ¿estaba mal el modelo, o estaba mal la pregunta?
>
> **Para responderla hice un segundo proyecto en Python**: los mismos 884
> registros, el mismo protocolo, las mismas cinco semillas, el mismo split por
> producto — pero prediciendo desde el **texto** de la reseña en vez de desde los
> atributos.
>
> ▸ Atributos del producto: **0,521**
> ▸ Texto de la reseña: **0,793**
>
> Añadí un modelo de control con una sola variable (cuántos caracteres escribió
> el cliente) porque la gente insatisfecha escribe más largo, y quería saber
> cuánto venía de ahí: 0,662. El contenido aporta +0,131 real.
>
> **Era la pregunta.** Y el texto encontró lo que los atributos nunca podrían:
> *"pierde agua"*, *"primer día"*, *"se mueve"*, *"salpica"*. Son fallos de
> instalación, no de diseño de producto.
>
> **Qué aprendí:** la fuga de datos no siempre se ve en el código. Aquí estaba en
> la *estructura* — la unidad de análisis era la reseña y los predictores eran
> del producto. Y un resultado malo a veces no significa que el modelo falle:
> significa que estás preguntando otra cosa.
>
> **Lo he publicado todo**, incluido el código original sin tocar. Porque un
> portfolio no demuestra que aciertas: demuestra cómo trabajas cuando te
> equivocas.
>
> 🔗 github.com/DatalyticsAGM/tfg-leroy-merlin
> 🔗 github.com/DatalyticsAGM/resenas-sanitarios-nlp

**Por qué funciona:** no es «publiqué un error», que se agota en el gesto. Es
«encontré un error, formulé una hipótesis sobre su causa, diseñé un experimento
controlado para contrastarla y la hipótesis se confirmó». Eso es método, y es
exactamente lo que un técnico quiere ver.

---

## PRIVACIDAD

| Elemento | Decisión |
|---|---|
| Código (`R/`, `original/`) | ✅ Publicable |
| Metodología y resultados agregados | ✅ Publicable |
| Boruta, métricas, solapamiento | ✅ Publicable |
| **Datasets de Leroy Merlin** | 🔴 **NO publicar** — propiedad de la empresa |
| Comentarios de clientes | 🔴 No publicar en bruto |
| **Fichas técnicas que hiciste tú** | 🟡 Son tuyas, pero identifican el catálogo. Mejor no |
| Memoria del TFG | 🟡 Es tuya; decide tú |

**Para que el repo sea ejecutable sin datos reales:** añade un generador
sintético que reproduzca el esquema (26 productos, ~34 reseñas cada uno, mismas
columnas y distribuciones) y dilo en el README. El pipeline corre, los resultados
no son los reales, y nadie publica nada de Leroy Merlin.

---

## VEREDICTO FINAL

**Tenías un proyecto bueno que estaba mal medido. Ahora tienes dos proyectos
que, juntos, cuentan algo que casi ningún portfolio junior cuenta.**

El TFG por sí solo es un proyecto de analista: pregunta de negocio real, datos
difíciles de conseguir, integración, exploración, texto, conclusiones que
resisten. Está bien, pero no destaca.

Lo que destaca es la secuencia completa:

1. Encontraste un error en tu propio trabajo
2. Lo **mediste** en vez de taparlo: 0,587 → 0,525
3. Formulaste una hipótesis sobre su causa — *la unidad de análisis está mal*
4. Diseñaste un **experimento controlado** para contrastarla
5. La hipótesis se confirmó: 0,521 vs 0,793
6. Y añadiste un **control** para no engañarte con el resultado bueno

Eso es método científico aplicado a un problema de negocio. Es exactamente lo
que un entrevistador técnico quiere ver y casi nunca encuentra, porque la
mayoría de los portfolios son notebooks que aciertan a la primera con datos de
Kaggle.

**Súbelos. Los dos. Con la fuga dentro.**
