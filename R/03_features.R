# ============================================================
# 03_features.R — Variable objetivo y predictores
# ============================================================

## Definición de QUEJAS, tal y como la justifica el autor en el original (L1419):
##   "observaciones de 5 estrellas no hay quejas, por ello agruparemos las
##    observaciones en 5 = Perfecto y 1-4 No perfecto"
construir_objetivo <- function(db) {
  bruto <- db[["VALORACION RESEÑA"]]
  # [CORRECCIÓN 9] El original recodificaba 1-5 a palabras (UNO..CINCO) en un
  # punto posterior del script. Aquí se acepta cualquiera de las dos formas,
  # de modo que el pipeline no depende de ese paso intermedio.
  v <- toupper(trimws(as.character(bruto)))
  palabras <- c("UNO" = 1, "DOS" = 2, "TRES" = 3, "CUATRO" = 4, "CINCO" = 5)
  num <- suppressWarnings(as.numeric(v))
  num[is.na(num)] <- unname(palabras[v[is.na(num)]])
  cat("  escala detectada:", if (any(v %in% names(palabras))) "palabras" else "numérica",
      "| valores:", paste(sort(unique(num)), collapse = ", "), "\n")

  db$QUEJAS <- factor(ifelse(num == 5, "NO", "SI"), levels = c("SI", "NO"))
  n_na <- sum(is.na(db$QUEJAS))
  if (n_na) cat("  descartadas", n_na, "filas sin valoración\n")
  db <- db[!is.na(db$QUEJAS), ]
  cat("  QUEJAS -> SI:", sum(db$QUEJAS == "SI"), "| NO:", sum(db$QUEJAS == "NO"),
      sprintf("| baseline: %.4f\n", max(prop.table(table(db$QUEJAS)))))
  db
}

## Predictores: atributos técnicos del producto (los del original)
PREDICTORES <- c("MARCA", "FONDO REDUCIDO", "RIMLESS", "TAPA AMORTIGUADA",
                 "SALIDA DUAL", "TAPA EXTRAIBLE", "COLOR", "GARANTIA",
                 "PRECIO", "TOP 2500", "MARCA PROPIA")

preparar_modelado <- function(db, clave = "Descripción") {
  preds <- intersect(PREDICTORES, names(db))
  faltan <- setdiff(PREDICTORES, preds)
  if (length(faltan)) cat("  AVISO: no están en los datos:", paste(faltan, collapse = ", "), "\n")

  d <- db[, c(preds, "QUEJAS", clave)]
  names(d) <- make.names(names(d))
  for (p in make.names(preds)) if (is.character(d[[p]])) d[[p]] <- factor(d[[p]])

  # Diagnóstico de duplicación de vectores (el original no lo hacía)
  pn <- make.names(preds)
  vec <- apply(d[, pn, drop = FALSE], 1, paste, collapse = "|")
  cat(sprintf("  %d filas / %d vectores de predictores únicos -> cada uno se repite %.1f veces\n",
              length(vec), length(unique(vec)), length(vec) / length(unique(vec))))

  list(datos = d, predictores = pn, clave = make.names(clave))
}
