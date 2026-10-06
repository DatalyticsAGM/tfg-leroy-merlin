# ============================================================
# 01_import.R — Carga de las fuentes originales
# ============================================================
# Replica las lecturas del script original (L43-45, L317).
#
# [CORRECCIÓN 5] El original codificaba los nombres de fichero literalmente.
#   Uno de ellos ("DS0007- HI Ecommerce 1 de enero 2020  - 30 agosto 2022.xlsx")
#   contiene un ESPACIO NO SEPARABLE (U+00A0) invisible, de modo que cualquier
#   ruta escrita a mano falla aunque el nombre parezca idéntico.
#   Aquí los ficheros se localizan por patrón, normalizando los espacios.
# ============================================================

# Normaliza cualquier tipo de espacio Unicode a un espacio simple
norm_sp <- function(x) gsub("\\s+", " ", gsub("\u00A0|\u2007|\u202F", " ", x))

buscar_fichero <- function(carpeta, patron, etiqueta) {
  if (!dir.exists(carpeta)) stop("No existe la carpeta: ", carpeta)
  todos <- list.files(carpeta, pattern = "\\.xlsx$", full.names = FALSE)
  hit <- todos[grepl(patron, norm_sp(todos), ignore.case = TRUE)]
  if (length(hit) == 0) {
    stop("No se encuentra el fichero de '", etiqueta, "' con el patrón:\n  ", patron,
         "\nEn: ", carpeta,
         "\nDisponibles:\n  ", paste(todos, collapse = "\n  "))
  }
  if (length(hit) > 1) {
    cat("  AVISO: varios candidatos para '", etiqueta, "'; se usa el primero:\n    ",
        paste(hit, collapse = "\n    "), "\n", sep = "")
  }
  file.path(carpeta, hit[1])
}

importar_datos <- function(ruta = RUTA_DATOS) {

  carpeta_ds <- file.path(ruta, "Datasets Valoraciones productos")

  log_paso("Localizando ficheros de entrada...")
  ficheros <- list(
    rcomen    = buscar_fichero(carpeta_ds, "^DS0043.*DETALLE COMENTARIOS",      "comentarios"),
    rven      = buscar_fichero(carpeta_ds, "^DS0043.*VALORACI.N CLIENTES",      "valoraciones"),
    ronline   = buscar_fichero(carpeta_ds, "^DS0007.*Ecommerce 1 de enero 2020", "ventas online"),
    variables = file.path(ruta, "datawcsuelo con variable.xlsx")
  )

  if (!file.exists(ficheros$variables)) {
    alt <- list.files(ruta, pattern = "datawcsuelo.*variable", full.names = TRUE)
    if (length(alt)) ficheros$variables <- alt[1]
    else stop("No se encuentra 'datawcsuelo con variable.xlsx' en ", ruta)
  }

  for (n in names(ficheros)) cat("  [OK] ", n, ": ", basename(ficheros[[n]]), "\n", sep = "")

  log_paso("Leyendo...")
  d <- lapply(ficheros, function(f) suppressMessages(readxl::read_xlsx(f)))
  for (n in names(d)) {
    cat(sprintf("  %-10s %7d filas x %3d cols\n", n, nrow(d[[n]]), ncol(d[[n]])))
  }
  d
}
