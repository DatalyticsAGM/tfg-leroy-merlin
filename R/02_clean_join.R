# ============================================================
# 02_clean_join.R — Limpieza, filtrado y uniones
# ============================================================
# Replica la lógica del original (L132-240) con dos cambios:
#   [CORRECCIÓN 4] Uniones con `by=` explícito y auditoría de filas
#   [CORRECCIÓN 6] Se reporta cuántas filas nulas se descartan
# ============================================================

# Productos excluidos a mano en el original (L206-215): no son inodoros
# completos, sino tapas, cisternas y códigos agregados.
EXCLUIR <- c(
  "TAPA WC ROCA CASSANDRA", "COD 48 APARATOS SANITARIOS",
  "CISTERNA ALIMENTACION LATERAL MISTRAL",
  "TAPA WC ROCA MERIDIAN N/COMP C/LIBRE BLA",
  "TAPA INODORO AMORTIGUADA BAU GROHE", "CISTERNA WC IDEALIVE",
  "CISTERNA WC OUTLINE/AFFINITY/TYRIA",
  "TAPA WC GALA NORTE CAIDA AMORTIGUADA", "CISTERNA AL/LATERAL ACCESS"
)

limpiar_y_unir <- function(d) {

  ## --- Renombrado y recodificación (original L132-152) -----------------
  log_paso("Limpieza de fuentes...")

  rcomen1 <- d$rcomen |>
    dplyr::rename(`MARCA PROPIA` = `TOP MDH`, `TIPO DE CLIENTE` = FIDELIDAD,
                  ID_PRODUCTOS = `Nº REFERENCIA`)
  rcomen1$`MARCA PROPIA` <- stringr::str_replace_all(rcomen1$`MARCA PROPIA`,
                                                     c("No MDH" = "NO", "MDH" = "SI"))
  rcomen1$`TOP 2500` <- stringr::str_replace_all(rcomen1$`TOP 2500`,
                                                 c("No TOP 2500" = "NO", "TOP 2500" = "SI"))

  rven1 <- d$rven |>
    dplyr::rename(`MARCA PROPIA` = `TOP MDH`, ID_PRODUCTOS = `Nº REFERENCIA`)
  rven1$`MARCA PROPIA` <- stringr::str_replace_all(rven1$`MARCA PROPIA`,
                                                   c("No MDH" = "NO", "MDH" = "SI"))
  rven1$`TOP 2500` <- stringr::str_replace_all(rven1$`TOP 2500`,
                                               c("No TOP 2500" = "NO", "TOP 2500" = "SI"))

  ronline <- d$ronline |> dplyr::rename(ID_PRODUCTOS = `Nº Artículo`)

  ## --- Filtrado de nulos (original L157) --------------------------------
  n_antes <- nrow(rcomen1)
  rcomen1na <- rcomen1[!is.na(rcomen1$`VALORACIÓN MEDIA`), ]
  cat(sprintf("  rcomen: %d -> %d filas (descartadas %d sin VALORACIÓN MEDIA)\n",
              n_antes, nrow(rcomen1na), n_antes - nrow(rcomen1na)))

  ## --- Filtro de sección SANITARIO (original L160-162) ------------------
  Sanrven1   <- dplyr::filter(rven1,     SECCIÓN == "SANITARIO")
  Sanrcomen1 <- dplyr::filter(rcomen1na, SECCIÓN == "SANITARIO")
  Sanroline1 <- dplyr::filter(ronline,   Sección == "SANITARIO")
  cat(sprintf("  SANITARIO -> rven: %d | rcomen: %d | online: %d\n",
              nrow(Sanrven1), nrow(Sanrcomen1), nrow(Sanroline1)))

  ## --- WC a suelo y exclusiones (original L177-215) ---------------------
  datawcsuelo <- dplyr::filter(Sanroline1, Tipo == "WC A SUELO")
  n0 <- nrow(datawcsuelo)
  datawcsuelo <- datawcsuelo[!(datawcsuelo$Descripción %in% EXCLUIR), ]
  cat(sprintf("  WC A SUELO: %d -> %d (excluidos %d: tapas, cisternas y agregados)\n",
              n0, nrow(datawcsuelo), n0 - nrow(datawcsuelo)))

  ## --- Variable PRECIO (original L217) ----------------------------------
  datawcsuelo <- dplyr::mutate(datawcsuelo, PRECIO = Importe / Cantidad)

  ## --- UNIONES (original L227-240) --------------------------------------
  # [CORRECCIÓN 4] El original usaba merge() SIN `by=`: la clave quedaba
  # implícita (todas las columnas comunes). Aquí es explícita y auditada.
  log_paso("Uniones (con clave explícita y auditoría)...")

  comunes1 <- intersect(names(datawcsuelo), names(Sanrcomen1))
  cat("  clave union 1:", paste(comunes1, collapse = ", "), "\n")
  dataprueba <- merge(datawcsuelo, Sanrcomen1, by = comunes1)
  informe_union("1) wcsuelo + comentarios", datawcsuelo, Sanrcomen1, dataprueba, "Descripción")

  dataprueba <- dplyr::rename(dataprueba, `VALORACION RESEÑA` = `VALORACIÓN MEDIA`)

  comunes2 <- intersect(names(dataprueba), names(Sanrven1))
  cat("  clave union 2:", paste(comunes2, collapse = ", "), "\n")
  datadefinitivo <- merge(dataprueba, Sanrven1, by = comunes2)
  informe_union("2) + valoraciones", dataprueba, Sanrven1, datadefinitivo, "Descripción")

  datadefinitivo <- dplyr::select(datadefinitivo,
                                  -dplyr::any_of(c("UDS. VENDIDAS 12M", "VENTA12M", "GAMA")))

  comunes3 <- intersect(names(d$variables), names(datadefinitivo))
  cat("  clave union 3:", paste(comunes3, collapse = ", "), "\n")
  databoceto <- merge(d$variables, datadefinitivo, by = comunes3)
  informe_union("3) + variables técnicas", d$variables, datadefinitivo, databoceto, "Descripción")

  ## --- Diagnóstico de la estructura (el original no lo hacía) -----------
  n_prod <- length(unique(databoceto$Descripción))
  cat(sprintf("\n  >> databoceto: %d filas / %d productos = %.1f filas por producto\n",
              nrow(databoceto), n_prod, nrow(databoceto) / n_prod))
  cat("  >> Esta estructura es la causa de la fuga: ver 04_split.R\n\n")

  databoceto
}
