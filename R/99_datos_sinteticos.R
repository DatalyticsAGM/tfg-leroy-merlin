# ============================================================
# 99_datos_sinteticos.R — Datos sintéticos para ejecución pública
# ============================================================
# PARA QUÉ SIRVE
#   Los datos originales son propiedad de Leroy Merlin y NO se publican.
#   Sin ellos el repositorio no se puede ejecutar, y un pipeline que nadie
#   puede correr no demuestra reproducibilidad.
#
#   Este script genera un dataset con la MISMA ESTRUCTURA que el real
#   (26 productos, ~34 reseñas cada uno, mismas columnas, mismos tipos),
#   de modo que `run_all.R` corre de principio a fin sin datos reales.
#
# LO QUE NO ES
#   No es una copia anonimizada ni una imputación de los datos de Leroy
#   Merlin. Los parámetros de abajo están INVENTADOS a mano: no se han
#   ajustado sobre el dataset real. Por tanto:
#
#     >>> LOS RESULTADOS CON DATOS SINTÉTICOS NO SON LOS RESULTADOS
#     >>> DEL TFG. Los reales están en output/results/ y en el README.
#
#   Lo que sí se conserva —y es lo que importa para demostrar el
#   problema— es la ESTRUCTURA que causa la fuga: pocos productos,
#   muchas reseñas por producto, y predictores constantes dentro del
#   producto.
# ============================================================

N_PRODUCTOS_SINT <- 26
RESENAS_POR_PRODUCTO <- c(min = 18, max = 55)

generar_datos_sinteticos <- function(n_productos = N_PRODUCTOS_SINT,
                                     semilla = SEMILLA) {
  set.seed(semilla)

  marcas <- c("MARCA_A", "MARCA_B", "MARCA_C", "MARCA_D", "MARCA_PROPIA_X")
  colores <- c("BLANCO", "BLANCO MATE", "GRIS", "NEGRO")

  # --- Catálogo: un producto = una fila. Aquí nacen los predictores -----
  cat_prod <- data.frame(
    `ID_PRODUCTOS`      = sprintf("SINT-%04d", seq_len(n_productos)),
    `Descripción`       = sprintf("WC A SUELO SINTETICO %02d", seq_len(n_productos)),
    `MARCA`             = sample(marcas, n_productos, replace = TRUE,
                                 prob = c(.3, .25, .2, .15, .1)),
    `PRECIO`            = round(exp(rnorm(n_productos, log(180), 0.55)), 2),
    `FONDO REDUCIDO`    = sample(c("SI", "NO"), n_productos, TRUE, c(.35, .65)),
    `RIMLESS`           = sample(c("SI", "NO"), n_productos, TRUE, c(.45, .55)),
    `TAPA AMORTIGUADA`  = sample(c("SI", "NO"), n_productos, TRUE, c(.55, .45)),
    `SALIDA DUAL`       = sample(c("SI", "NO"), n_productos, TRUE, c(.6, .4)),
    `TAPA EXTRAIBLE`    = sample(c("SI", "NO"), n_productos, TRUE, c(.4, .6)),
    `COLOR`             = sample(colores, n_productos, TRUE, c(.7, .15, .1, .05)),
    `GARANTIA`          = sample(c("2 AÑOS", "5 AÑOS", "25 AÑOS"), n_productos,
                                 TRUE, c(.5, .3, .2)),
    `TOP 2500`          = sample(c("SI", "NO"), n_productos, TRUE, c(.3, .7)),
    check.names = FALSE, stringsAsFactors = FALSE
  )
  cat_prod$`MARCA PROPIA` <- ifelse(cat_prod$MARCA == "MARCA_PROPIA_X", "SI", "NO")

  # --- Probabilidad de NO queja, por producto --------------------------
  # Efectos declarados a mano, no estimados. Se hacen DÉBILES a propósito:
  # el hallazgo real del TFG es que estos atributos explican poco, y un
  # generador con señal fuerte daría una falsa sensación de que el modelo
  # funciona.
  # El intercepto se fija para que el balance de clases quede cerca del real
  # (54 % con queja / 46 % sin queja). Es el único parámetro calibrado, y se
  # calibra contra una cifra ya publicada en el README, no contra los datos.
  z <- -0.55 +
    0.0022 * (cat_prod$PRECIO - mean(cat_prod$PRECIO)) +
    0.35 * (cat_prod$`TAPA AMORTIGUADA` == "SI") +
    0.20 * (cat_prod$RIMLESS == "SI") +
    0.30 * (cat_prod$MARCA %in% c("MARCA_A", "MARCA_B")) -
    0.25 * (cat_prod$`MARCA PROPIA` == "SI") +
    rnorm(n_productos, 0, 0.45)          # heterogeneidad no observada
  cat_prod$p_sin_queja <- 1 / (1 + exp(-z))

  # --- Reseñas: varias por producto ------------------------------------
  n_res <- sample(RESENAS_POR_PRODUCTO["min"]:RESENAS_POR_PRODUCTO["max"],
                  n_productos, replace = TRUE)
  idx <- rep(seq_len(n_productos), times = n_res)
  db <- cat_prod[idx, , drop = FALSE]

  sin_queja <- runif(nrow(db)) < db$p_sin_queja
  # Escala 1-5. Las reseñas con queja se reparten entre 1 y 4.
  db$`VALORACION RESEÑA` <- ifelse(sin_queja, 5L,
                                   sample(1:4, nrow(db), TRUE, c(.25, .2, .25, .3)))
  db$p_sin_queja <- NULL
  rownames(db) <- NULL

  cat(sprintf("  datos SINTÉTICOS: %d reseñas de %d productos (%.1f por producto)\n",
              nrow(db), n_productos, nrow(db) / n_productos))
  cat("  AVISO: estos NO son los datos del TFG. Resultados no comparables.\n")
  db
}
