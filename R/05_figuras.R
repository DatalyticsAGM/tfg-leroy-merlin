# ============================================================
# 05_figuras.R — Figuras del proyecto
# ============================================================
# [CORRECCIÓN 10] El original generaba ~45 gráficos con theme_ipsum_tw(),
# función eliminada de hrbrthemes, y ninguno quedaba guardado en disco:
# se veían en el panel de RStudio y se perdían. Aquí se guardan en
# output/figures/ y el tema es theme_minimal(), disponible en base ggplot2.
#
# Las cuatro figuras responden a las cuatro afirmaciones del README.
# ============================================================

guardar <- function(g, nombre, w = 7, h = 4.5) {
  f <- file.path(DIR_FIGURAS, paste0(nombre, ".png"))
  ggplot2::ggsave(f, g, width = w, height = h, dpi = 150, bg = "white")
  cat("  ", basename(f), "\n", sep = "")
  invisible(f)
}

# --- 1. La fuga, dibujada ----------------------------------------------
# 884 filas pero sólo 27 vectores de predictores distintos. Es el gráfico
# que explica por qué el split aleatorio no podía funcionar.
fig_fuga <- function(prep) {
  d <- prep$datos
  vec <- apply(d[, prep$predictores, drop = FALSE], 1, paste, collapse = "|")
  tab <- as.data.frame(table(vec), stringsAsFactors = FALSE)
  tab <- tab[order(-tab$Freq), ]
  tab$i <- seq_len(nrow(tab))

  g <- ggplot2::ggplot(tab, ggplot2::aes(x = i, y = Freq)) +
    ggplot2::geom_col(fill = "#c0392b", width = 0.8) +
    ggplot2::geom_hline(yintercept = 1, linetype = "dashed", colour = "grey40") +
    ggplot2::annotate("text", x = nrow(tab) * 0.55, y = max(tab$Freq) * 0.85,
      hjust = 0, size = 3.4, colour = "grey20",
      label = sprintf("%d filas\n%d vectores únicos\ncada uno se repite %.1f veces",
                      nrow(d), nrow(tab), nrow(d) / nrow(tab))) +
    ggplot2::labs(
      title = "Por qué el split aleatorio por fila produce fuga",
      subtitle = "Los predictores son atributos del PRODUCTO: se repiten en todas sus reseñas",
      x = "Vector de predictores (ordenado)", y = "Reseñas que lo comparten") +
    TEMA
  guardar(g, "01_fuga_vectores_repetidos")
}

# --- 2. Solapamiento train/test ---------------------------------------
fig_solape <- function(solape) {
  g <- ggplot2::ggplot(solape, ggplot2::aes(x = factor(semilla),
                                            y = pct_filas_test_ya_vistas)) +
    ggplot2::geom_col(fill = "#c0392b", width = 0.6) +
    ggplot2::geom_text(ggplot2::aes(label = sprintf("%.1f%%", pct_filas_test_ya_vistas)),
                       vjust = -0.4, size = 3.2) +
    ggplot2::scale_y_continuous(limits = c(0, 108)) +
    ggplot2::labs(
      title = "Filas de test que pertenecen a un producto ya visto en entrenamiento",
      subtitle = "Split original: initial_split() aleatorio por fila",
      x = "Semilla", y = "% de filas de test contaminadas") +
    TEMA
  guardar(g, "02_solapamiento_train_test", h = 4)
}

# --- 3. Boruta ---------------------------------------------------------
fig_boruta <- function(bor) {
  st <- bor$stats
  df <- data.frame(variable = gsub("\\.", " ", rownames(st)), imp = st$meanImp,
                   decision = as.character(st$decision))
  df$variable <- factor(df$variable, levels = df$variable[order(df$imp)])

  g <- ggplot2::ggplot(df, ggplot2::aes(x = imp, y = variable, fill = decision)) +
    ggplot2::geom_col(width = 0.7) +
    ggplot2::scale_fill_manual(values = c(Confirmed = "#1e8449", Tentative = "#d4ac0d",
                                          Rejected = "#99a3a4"), name = NULL) +
    ggplot2::labs(
      title = "Importancia de los atributos (Boruta, 100 iteraciones)",
      subtitle = "Marca y precio son los dos ejes de las conclusiones de la memoria",
      x = "Importancia media", y = NULL) +
    TEMA + ggplot2::theme(legend.position = "bottom")
  guardar(g, "03_boruta_importancia", h = 5)
}

# --- 4. AUC original vs corregido -------------------------------------
fig_auc <- function(resultados, baseline, auc_memoria = 0.617) {
  df <- resultados
  df$split <- ifelse(df$split == "A_original_aleatorio",
                     "A · aleatorio por fila (original)",
                     "B · agrupado por producto (corregido)")
  df$modelo <- ifelse(df$modelo == "logistica", "Regresión logística", "Random Forest")

  # Se usan PUNTOS y no barras a propósito: el rango de interés es 0,45-0,65
  # y unas barras con el eje recortado exagerarían visualmente la diferencia.
  # Sería el mismo tipo de error que este proyecto denuncia.
  medias <- stats::aggregate(auc ~ modelo + split, df, mean)
  dodge  <- ggplot2::position_dodge(width = 0.5)

  g <- ggplot2::ggplot(df, ggplot2::aes(x = modelo, y = auc, colour = split)) +
    ggplot2::geom_hline(yintercept = baseline, linetype = "dashed", colour = "grey35") +
    ggplot2::geom_hline(yintercept = auc_memoria, linetype = "dotted", colour = "#2471a3") +
    ggplot2::geom_point(position = ggplot2::position_jitterdodge(
                          jitter.width = 0.12, dodge.width = 0.5, seed = 1),
                        size = 1.8, alpha = 0.45) +
    ggplot2::geom_point(data = medias, position = dodge, size = 5, shape = 18) +
    ggplot2::geom_text(data = medias, ggplot2::aes(label = sprintf("%.3f", auc)),
                       position = dodge, vjust = -1.3, size = 3.3, show.legend = FALSE) +
    ggplot2::annotate("text", x = 0.55, y = baseline - 0.008, hjust = 0, size = 3,
                      colour = "grey35", label = sprintf("baseline %.3f", baseline)) +
    ggplot2::annotate("text", x = 0.55, y = auc_memoria + 0.007, hjust = 0, size = 3,
                      colour = "#2471a3", label = sprintf("memoria %.3f", auc_memoria)) +
    ggplot2::scale_colour_manual(values = c("#c0392b", "#1e8449"), name = NULL) +
    ggplot2::coord_cartesian(ylim = c(0.47, 0.66)) +
    ggplot2::labs(
      title = "El coste exacto de corregir la fuga",
      subtitle = "Rombo = media de 5 semillas · puntos = cada semilla · eje recortado",
      x = NULL, y = "AUC en test") +
    TEMA + ggplot2::theme(legend.position = "bottom")
  guardar(g, "04_auc_original_vs_corregido", w = 7.5, h = 4.8)
}

# --- 5. Negocio: precio y quejas --------------------------------------
# La conclusión central de la memoria, en un gráfico.
fig_precio <- function(prep) {
  d <- prep$datos
  if (!"PRECIO" %in% names(d)) return(invisible(NULL))
  d$PRECIO <- suppressWarnings(as.numeric(as.character(d$PRECIO)))
  d <- d[!is.na(d$PRECIO), ]
  if (!nrow(d)) return(invisible(NULL))

  g <- ggplot2::ggplot(d, ggplot2::aes(x = QUEJAS, y = PRECIO, fill = QUEJAS)) +
    ggplot2::geom_boxplot(width = 0.5, outlier.alpha = 0.3) +
    ggplot2::scale_fill_manual(values = c(SI = "#c0392b", NO = "#1e8449"), guide = "none") +
    ggplot2::labs(
      title = "Precio del producto según haya queja o no",
      subtitle = "QUEJAS = SI cuando la reseña es de 1 a 4 estrellas",
      x = "¿Hay queja?", y = "Precio (€)") +
    TEMA
  guardar(g, "05_precio_vs_quejas", w = 5.5, h = 4)
}

generar_figuras <- function(prep, bor, comp) {
  cat("\n--- Figuras ---\n")
  baseline <- max(prop.table(table(prep$datos$QUEJAS)))
  fig_fuga(prep)
  fig_solape(comp$solape)
  fig_boruta(bor)
  fig_auc(comp$resultados, baseline)
  fig_precio(prep)
  invisible(TRUE)
}
