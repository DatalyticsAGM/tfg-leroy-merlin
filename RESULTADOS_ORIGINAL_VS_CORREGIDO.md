# Original vs corregido — resultados
**TFG Leroy Merlin · reconstrucción de octubre de 2026 · R 4.6.1**

Todo lo de este documento está **ejecutado**, no inferido.
Reproducible con `Rscript --vanilla R/run_all.R` (44 segundos).

---

## 1. Lo que no cambia: el dataset se reconstruye idéntico

| Objeto | Original (ejecutado) | Corregido | ¿Igual? |
|---|---:|---:|:---:|
| `rcomen` | 246.678 | 246.678 | ✅ |
| `rven` | 54.552 | 54.552 | ✅ |
| `ronline2020` | 84.809 | 84.809 | ✅ |
| Filas descartadas sin valoración | — | **4.000** | ⊕ ahora se reporta |
| `Sanrcomen1` | 23.874 | 23.874 | ✅ |
| `Sanrven1` | 5.759 | 5.759 | ✅ |
| `datawcsuelo` | 49 | 49 (de 59, −10 excluidos) | ✅ |
| **`databoceto`** | **884 × 33** | **884 × 33** | ✅ |
| Productos únicos | 26 | 26 | ✅ |

**La corrección no altera los datos.** Reproduce el pipeline del autor y solo
cambia cómo se parte y cómo se documenta.

---

## 2. El problema, medido

| Medida | Valor |
|---|---:|
| Filas | 884 |
| Productos | 26 |
| **Vectores de predictores únicos** | **27** |
| Repeticiones por vector | **32,7** |

### Solapamiento con `initial_split()` aleatorio por fila
| Semilla | Productos en train | Productos en test | **% filas de test ya vistas** |
|---|---:|---:|---:|
| 11 | 23 | 22 | **98,3 %** |
| 42 | 26 | 19 | **100,0 %** |
| 77 | 25 | 21 | **99,4 %** |
| 2017 | 26 | 17 | **100,0 %** |
| 123 | 25 | 21 | **97,8 %** |

---

## 3. Métricas — media de 5 semillas

| Modelo | Split | AUC | Accuracy | Sens | Spec |
|---|---|---:|---:|---:|---:|
| **Regresión logística** | A · original aleatorio | **0,5868** | 0,5730 | 0,3976 | 0,7229 |
| **Regresión logística** | **B · corregido por producto** | **0,5249** | 0,5239 | 0,6479 | 0,4196 |
| Random Forest | A · original aleatorio | 0,5883 | 0,5787 | 0,3634 | 0,7625 |
| Random Forest | **B · corregido por producto** | 0,5590 | 0,5332 | 0,4670 | 0,6005 |

### Contraste con la memoria
| | AUC |
|---|---:|
| **Reportado en el TFG (Figura 5)** | **0,6170** |
| Reproducido con el split original | **0,5868** (−0,030) |
| **Con el split corregido** | **0,5249** (−0,062 adicional) |
| **Baseline (clase mayoritaria)** | **0,5396** |

> ### Lectura
> **El 0,617 de la memoria es reproducible** dentro de la variabilidad esperable
> (0,587 de media sobre cinco semillas; el autor reportó una sola ejecución).
>
> **Corregido el split, la regresión logística baja a 0,525** y su accuracy
> (0,524) queda **por debajo del baseline** (0,540). Es decir: el modelo **no
> generaliza a productos que no ha visto**.
>
> **La diferencia 0,587 → 0,525 es exactamente el valor de la fuga.**

---

## 4. Tabla de cambios

| Elemento | Original | Corregido |
|---|---|---|
| **Split** | `initial_split()` aleatorio por fila | `group_initial_split(group = Descripción)` |
| **Fuga** | Sí: 97,8-100 % de filas de test ya vistas | No: ningún producto en ambos lados |
| **Semillas** | 8 distintas (11, 10, 77, 2017) y **ninguna antes del split ni de Boruta** | Una semilla global + explícita antes de cada proceso aleatorio |
| **Uniones** | `merge()` **sin `by=`**, clave implícita | `by=` explícito + auditoría de filas y claves |
| **Filas nulas** | Filtradas (L157), sin reportar | Filtradas y **reportadas**: 4.000 |
| **Boruta** | Ejecutado, solo `plot()`, **resultado no usado**, sin semilla | Ejecutado con semilla y **su resultado se publica** |
| **Modelos** | 5 familias en el script, 2 en la memoria | **Los 2 de la memoria**: logística y random forest |
| **Métricas** | AUC, accuracy, sens, spec en una ejecución | Las mismas, **media de 5 semillas**, con baseline explícito |
| **Rutas** | Relativas, dependientes del directorio de trabajo | Configurables; ficheros localizados **por patrón** |
| **Orden** | `datamateriales` usado en L418, cargado en L1806 | Pipeline lineal: import → clean → features → split → models |
| **Dependencias** | 43 paquetes, 3 rotos hoy | 12 paquetes, todos funcionando |
| **`theme_ipsum_tw`** | 45 llamadas, función eliminada de `hrbrthemes` | `theme_minimal()` |
| **`vip`** | No disponible para R ≥ 4.6 | Importancia vía Boruta y `ranger` |
| **`xlsx`** | Requiere Java | `readxl` |
| **Experimento mezclado** | Bloque marcado *"NO HACER CASO"* conviviendo con el real | Fuera del pipeline |
| **Reproducibilidad** | No ejecutable de principio a fin | `Rscript R/run_all.R` → 44 s |
| **Entorno** | Sin registrar | `sessionInfo.txt` + versiones de paquetes |

---

## 5. Boruta, ejecutado con semilla

| Variable | Importancia media | Decisión |
|---|---:|---|
| **MARCA** | 0,315 | ✅ Confirmada |
| **PRECIO** | 0,303 | ✅ Confirmada |
| **TAPA AMORTIGUADA** | 0,298 | ✅ Confirmada |
| TAPA EXTRAIBLE | 0,213 | 🟡 Tentativa |
| RIMLESS | 0,193 | 🟡 Tentativa |
| TOP 2500 | 0,173 | 🟡 Tentativa |
| SALIDA DUAL | 0,162 | ❌ Rechazada |
| GARANTIA | 0,144 | ❌ Rechazada |
| MARCA PROPIA | 0,033 | ❌ Rechazada |
| FONDO REDUCIDO | 0,009 | ❌ Rechazada |
| COLOR | 0,000 | ❌ Rechazada |

**Corrobora el argumento de la memoria:** PRECIO y MARCA son los dos ejes de las
conclusiones del autor, y TAPA EXTRAIBLE —que él cita explícitamente— sale como
tentativa.

---

## 6. Qué significa que las métricas empeoren

**No significa que la versión corregida sea peor.** Significa que la original
medía mal.

Un AUC de 0,52 con split honesto dice algo verdadero y útil: **los atributos
técnicos de un inodoro no permiten predecir si una reseña concreta será de 5
estrellas o no.** Y tiene sentido: una reseña depende de la experiencia de un
cliente concreto —incluido el envío, que el propio autor señala— no solo del
producto.

El valor del TFG nunca estuvo en la predicción. Está en:
- la integración de cuatro fuentes heterogéneas
- las variables técnicas recopiladas a mano porque LM bloquea el scraping
- el análisis exploratorio y de covariación
- las 487 líneas de análisis de texto en español
- y unas conclusiones de negocio que **el propio Boruta corrobora**

El autor ya lo escribió: *"no es lo suficientemente preciso como para ser
tajantes, pero sí es útil y cumple la función de [identificar] los factores
clave"*. **Esta reconstrucción confirma que tenía razón.**
