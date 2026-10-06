# ============================================================
# 00_config.R — Configuración global del proyecto
# TFG Leroy Merlin · versión CORREGIDA (2026)
# ============================================================
# El código ORIGINAL permanece intacto en ../original/
# Cada corrección respecto al original está marcada con [CORRECCIÓN N]
# ============================================================

## --- Librería de usuario (evita escribir en Program Files) -------------
lib <- file.path(Sys.getenv("USERPROFILE"), "Documents", "R", "win-library", "4.6")
if (dir.exists(lib)) .libPaths(c(lib, .libPaths()))

## --- Rutas -------------------------------------------------------------
# [CORRECCIÓN 1] El original dependía de que el working directory fuese
# exactamente la carpeta `rrrr`. Aquí la ruta a los datos es explícita y
# configurable en un único sitio.
RUTA_DATOS <- Sys.getenv(
  "TFG_LM_DATOS",
  unset = "C:/Users/Usuario/Desktop/Claude/analisis datos/rrrr"
)

# [CORRECCIÓN 1b] La raíz del proyecto ya no está escrita a mano: run_all.R
# la deduce de su propia ubicación, de modo que el repositorio funciona
# clonado en cualquier carpeta. Sólo se usa este valor si nadie la ha fijado.
if (!exists("RUTA_PROY")) {
  RUTA_PROY <- Sys.getenv("TFG_LM_PROY", unset = normalizePath(".", mustWork = FALSE))
}
DIR_FIGURAS <- file.path(RUTA_PROY, "output", "figures")
DIR_RESULT  <- file.path(RUTA_PROY, "output", "results")
for (d in c(DIR_FIGURAS, DIR_RESULT)) dir.create(d, recursive = TRUE, showWarnings = FALSE)

## --- Semilla global ----------------------------------------------------
# [CORRECCIÓN 2] El original tenía 8 semillas distintas (11, 10, 77, 2017)
# y NINGUNA antes de initial_split() ni de Boruta. Aquí hay una sola,
# aplicada explícitamente antes de cada proceso aleatorio.
SEMILLA <- 2023

## --- Parámetros del análisis -------------------------------------------
PROPORCION_ENTRENAMIENTO <- 0.80
N_ARBOLES                <- 500
BORUTA_MAXRUNS           <- 100
SEMILLAS_REPETICION      <- c(11, 42, 77, 2017, 123)   # para medir variabilidad

## --- Paquetes ----------------------------------------------------------
# [CORRECCIÓN 3] El original cargaba 43 paquetes, varios inservibles hoy:
#   - `xlsx`            -> requiere Java. Sustituido por `readxl` (ya usado)
#   - `theme_ipsum_tw`  -> eliminado de hrbrthemes. Sustituido por theme_minimal
#   - `vip`             -> no disponible para R >= 4.6. Importancia vía ranger
PAQUETES <- c("readxl", "dplyr", "tidyr", "stringr", "ggplot2",
              "rsample", "parsnip", "recipes", "workflows", "yardstick",
              "ranger", "Boruta")

cargar_paquetes <- function() {
  faltan <- PAQUETES[!vapply(PAQUETES, requireNamespace, logical(1), quietly = TRUE)]
  if (length(faltan)) stop("Faltan paquetes: ", paste(faltan, collapse = ", "))
  invisible(lapply(PAQUETES, function(p)
    suppressPackageStartupMessages(library(p, character.only = TRUE))))
}

## --- Utilidades --------------------------------------------------------
log_paso <- function(...) cat(format(Sys.time(), "[%H:%M:%S] "), ..., "\n", sep = "")

# Informe de una unión: filas y claves antes/después. El original no lo hacía.
# [CORRECCIÓN 4] Toda unión queda auditada.
informe_union <- function(nombre, x, y, resultado, clave = NULL) {
  cat(sprintf("  %-22s  %6d x %6d -> %6d filas", nombre, nrow(x), nrow(y), nrow(resultado)))
  if (!is.null(clave) && clave %in% names(resultado)) {
    cat(sprintf("  | claves únicas: %d", length(unique(resultado[[clave]]))))
  }
  cat("\n")
  invisible(resultado)
}

TEMA <- ggplot2::theme_minimal(base_size = 11)
