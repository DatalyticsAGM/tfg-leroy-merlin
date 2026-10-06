# ============================================================
# run_all.R — Pipeline completo, reproducible, de principio a fin
# TFG Leroy Merlin · versión CORREGIDA
# ============================================================
# Uso:
#   Rscript --vanilla R/run_all.R                 # datos reales de Leroy Merlin
#   Rscript --vanilla R/run_all.R --sintetico     # datos sintéticos (sin datos reales)
#
# El modo --sintetico existe para que cualquiera pueda ejecutar el
# repositorio: los datos originales son propiedad de Leroy Merlin y no se
# publican. Los resultados sintéticos NO son los del TFG (ver R/99_datos_sinteticos.R).
# ============================================================

t0   <- Sys.time()
args <- commandArgs(trailingOnly = TRUE)
MODO_SINTETICO <- "--sintetico" %in% args

# --- Raíz del proyecto, deducida de la ubicación de este script ---------
# [CORRECCIÓN 1b] Antes era una ruta absoluta escrita a mano.
ruta_script <- sub("^--file=", "",
                   grep("^--file=", commandArgs(FALSE), value = TRUE)[1])
RUTA_PROY <- if (!is.na(ruta_script)) {
  normalizePath(file.path(dirname(ruta_script), ".."), mustWork = FALSE)
} else {
  normalizePath(".", mustWork = FALSE)   # ejecución interactiva desde la raíz
}
BASE <- RUTA_PROY

source(file.path(BASE, "R", "00_config.R"))
cargar_paquetes()
source(file.path(BASE, "R", "01_import.R"))
source(file.path(BASE, "R", "02_clean_join.R"))
source(file.path(BASE, "R", "03_features.R"))
source(file.path(BASE, "R", "04_split_models.R"))
source(file.path(BASE, "R", "05_figuras.R"))

cat("\nProyecto:", BASE, "\n")
cat("Modo:", if (MODO_SINTETICO) "DATOS SINTÉTICOS" else "datos reales", "\n")

if (MODO_SINTETICO) {
  source(file.path(BASE, "R", "99_datos_sinteticos.R"))
  cat("\n==================== 1-2. GENERACIÓN SINTÉTICA ====================\n")
  databoceto <- generar_datos_sinteticos()
} else {
  cat("\n==================== 1. IMPORTACIÓN ====================\n")
  datos <- importar_datos()

  cat("\n==================== 2. LIMPIEZA Y UNIONES ====================\n")
  databoceto <- limpiar_y_unir(datos)
}

cat("\n==================== 3. OBJETIVO Y PREDICTORES ====================\n")
databoceto <- construir_objetivo(databoceto)
prep <- preparar_modelado(databoceto)

cat("\n==================== 4. SELECCIÓN DE VARIABLES (BORUTA) ====================\n")
bor <- seleccion_boruta(prep)
print(bor$stats)
cat("\n  Confirmadas:", paste(bor$confirmadas, collapse = ", "), "\n")

cat("\n==================== 5. MODELOS: ORIGINAL vs CORREGIDO ====================\n")
comp <- comparar_estrategias(prep)

cat("\n--- Solapamiento de productos con el split ORIGINAL ---\n")
print(comp$solape)

resumen <- comp$resultados |>
  dplyr::group_by(modelo, split) |>
  dplyr::summarise(AUC = round(mean(auc), 4), Accuracy = round(mean(acc), 4),
                   Sens = round(mean(sens), 4), Spec = round(mean(spec), 4),
                   .groups = "drop") |>
  as.data.frame()

cat("\n--- RESULTADOS (media de", length(SEMILLAS_REPETICION), "semillas) ---\n")
print(resumen)

cat("\n--- CONTRASTE CON LA MEMORIA ---\n")
auc_memoria <- 0.617
auc_repro <- resumen$AUC[resumen$modelo == "logistica" &
                           resumen$split == "A_original_aleatorio"]
auc_corr  <- resumen$AUC[resumen$modelo == "logistica" &
                           resumen$split == "B_corregido_producto"]
baseline  <- max(prop.table(table(prep$datos$QUEJAS)))
cat(sprintf("  AUC en la memoria (Figura 5) ......... %.4f\n", auc_memoria))
cat(sprintf("  AUC reproducido (split original) ..... %.4f   (dif %+.4f)\n",
            auc_repro, auc_repro - auc_memoria))
cat(sprintf("  AUC con split por producto ........... %.4f   (dif %+.4f)\n",
            auc_corr, auc_corr - auc_repro))
cat(sprintf("  Baseline (clase mayoritaria) ......... %.4f\n", baseline))
if (MODO_SINTETICO) {
  cat("\n  >>> MODO SINTÉTICO: la comparación con la memoria no aplica.\n")
  cat("  >>> El 0,617 corresponde a los datos reales de Leroy Merlin.\n")
}

cat("\n==================== 6. FIGURAS ====================\n")
generar_figuras(prep, bor, comp)

## --- Guardar resultados ------------------------------------------------
# [CORRECCIÓN 11] En modo sintético los resultados van a otra carpeta para
# no sobrescribir los reales. Un `output/results/` mezclado sería
# exactamente el tipo de error que este proyecto denuncia.
sufijo <- if (MODO_SINTETICO) "_sintetico" else ""
dir_out <- if (MODO_SINTETICO) file.path(RUTA_PROY, "output", "results_sintetico") else DIR_RESULT
dir.create(dir_out, recursive = TRUE, showWarnings = FALSE)

write.csv(comp$resultados, file.path(dir_out, "resultados_completos.csv"), row.names = FALSE)
write.csv(resumen,         file.path(dir_out, "resumen_modelos.csv"),      row.names = FALSE)
write.csv(comp$solape,     file.path(dir_out, "solape_productos.csv"),     row.names = FALSE)
write.csv(data.frame(variable = rownames(bor$stats), bor$stats),
          file.path(dir_out, "boruta.csv"), row.names = FALSE)

## --- Dataset de análisis, para la versión Python -----------------------
# El proyecto hermano `resenas-sanitarios-nlp` consume este fichero en vez de
# reimplementar las tres uniones: así hay UNA sola definición del dataset y
# las dos versiones no pueden divergir.
# Va a data_interim/, que está en .gitignore: contiene texto de clientes.
dir_interim <- file.path(RUTA_PROY, "data_interim")
dir.create(dir_interim, recursive = TRUE, showWarnings = FALSE)
cols_exportar <- intersect(
  c("ID_PRODUCTOS", "Descripción", "QUEJAS", "VALORACION RESEÑA",
    "TITULO", "COMENTARIO", "TIPO DE CLIENTE", "FECHA CREACIÓN", PREDICTORES),
  names(databoceto))
f_exp <- file.path(dir_interim, paste0("databoceto", sufijo, ".csv"))
write.csv(databoceto[, cols_exportar], f_exp, row.names = FALSE, fileEncoding = "UTF-8")
cat("  dataset para Python:", basename(f_exp), "-",
    nrow(databoceto), "filas x", length(cols_exportar), "columnas\n")
if (!"COMENTARIO" %in% cols_exportar) {
  cat("  AVISO: no hay columna COMENTARIO; la versión Python no podrá usar texto.\n")
}

## --- Entorno (reproducibilidad) ----------------------------------------
capture.output(sessionInfo(), file = file.path(dir_out, "sessionInfo.txt"))
versiones <- data.frame(
  paquete = PAQUETES,
  version = vapply(PAQUETES, function(p) as.character(utils::packageVersion(p)), character(1))
)
write.csv(versiones, file.path(dir_out, "versiones_paquetes.csv"), row.names = FALSE)

cat("\n==================== FIN ====================\n")
cat("Resultados en:", dir_out, "\n")
cat("Figuras en:   ", DIR_FIGURAS, "\n")
cat("Tiempo total: ", round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1), "segundos\n")
