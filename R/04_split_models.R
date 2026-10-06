# ============================================================
# 04_split_models.R — Particionado, modelos y evaluación
# ============================================================
# [CORRECCIÓN 7 · LA IMPORTANTE]
#   El original usaba initial_split() aleatorio POR FILA. Como cada
#   producto tiene ~34 reseñas y los predictores son atributos DEL
#   PRODUCTO, el mismo vector de características caía en train y test.
#   Medido: 97-99,6 % de las filas de test pertenecían a un producto ya
#   visto. Aquí se usa group_initial_split() agrupando por producto.
#
#   Se mantienen AMBAS estrategias para poder cuantificar el efecto.
# ============================================================

receta_base <- function(d, preds) {
  recipes::recipe(QUEJAS ~ ., data = d[, c(preds, "QUEJAS")]) |>
    recipes::step_impute_mode(recipes::all_nominal_predictors()) |>
    recipes::step_impute_median(recipes::all_numeric_predictors()) |>
    recipes::step_novel(recipes::all_nominal_predictors()) |>
    recipes::step_dummy(recipes::all_nominal_predictors()) |>
    recipes::step_zv(recipes::all_predictors())
}

# Los dos modelos que REPORTA LA MEMORIA. Ni kNN, ni C5.0, ni árbol suelto:
# eso estaba en el script como exploración y nunca llegó al documento.
definir_modelos <- function() list(
  logistica     = parsnip::logistic_reg() |> parsnip::set_engine("glm") |>
                    parsnip::set_mode("classification"),
  random_forest = parsnip::rand_forest(trees = N_ARBOLES) |>
                    parsnip::set_engine("ranger") |> parsnip::set_mode("classification")
)

evaluar_modelo <- function(modelo, receta, entren, prueba, preds) {
  wf <- workflows::workflow() |> workflows::add_model(modelo) |> workflows::add_recipe(receta)
  ajuste <- parsnip::fit(wf, data = entren[, c(preds, "QUEJAS")])
  pred <- predict(ajuste, prueba, type = "prob") |>
    dplyr::bind_cols(predict(ajuste, prueba)) |>
    dplyr::bind_cols(prueba)
  c(auc  = yardstick::roc_auc(pred, truth = QUEJAS, .pred_SI)$.estimate,
    acc  = yardstick::accuracy(pred, truth = QUEJAS, estimate = .pred_class)$.estimate,
    sens = yardstick::sens(pred, truth = QUEJAS, estimate = .pred_class)$.estimate,
    spec = yardstick::spec(pred, truth = QUEJAS, estimate = .pred_class)$.estimate)
}

comparar_estrategias <- function(prep, semillas = SEMILLAS_REPETICION) {
  d <- prep$datos; preds <- prep$predictores; clave <- prep$clave
  rec <- receta_base(d, preds)
  modelos <- definir_modelos()
  res <- NULL; solape <- NULL

  for (s in semillas) {
    # A) ORIGINAL — aleatorio por fila
    set.seed(s)
    pa <- rsample::initial_split(d, prop = PROPORCION_ENTRENAMIENTO, strata = QUEJAS)
    ea <- rsample::training(pa); ta <- rsample::testing(pa)
    vistos <- unique(ea[[clave]])
    solape <- rbind(solape, data.frame(
      semilla = s,
      prod_train = length(vistos),
      prod_test  = length(unique(ta[[clave]])),
      pct_filas_test_ya_vistas = round(100 * mean(ta[[clave]] %in% vistos), 1)))

    # B) CORREGIDO — agrupado por producto
    set.seed(s)
    pb <- rsample::group_initial_split(d, group = !!rlang::sym(clave),
                                       prop = PROPORCION_ENTRENAMIENTO)
    eb <- rsample::training(pb); tb <- rsample::testing(pb)

    for (nm in names(modelos)) {
      a <- suppressWarnings(evaluar_modelo(modelos[[nm]], rec, ea, ta, preds))
      b <- suppressWarnings(evaluar_modelo(modelos[[nm]], rec, eb, tb, preds))
      res <- rbind(res,
        data.frame(modelo = nm, semilla = s, split = "A_original_aleatorio",  t(a)),
        data.frame(modelo = nm, semilla = s, split = "B_corregido_producto", t(b)))
    }
  }
  list(resultados = res, solape = solape)
}

seleccion_boruta <- function(prep) {
  # [CORRECCIÓN 8] El original ejecutaba Boruta y solo hacía plot().
  # Aquí se ejecuta con semilla y SE USA el resultado.
  set.seed(SEMILLA)
  d <- prep$datos[, c(prep$predictores, "QUEJAS")]
  b <- Boruta::Boruta(QUEJAS ~ ., data = d, doTrace = 0, maxRuns = BORUTA_MAXRUNS)
  conf <- Boruta::getSelectedAttributes(b, withTentative = FALSE)
  list(objeto = b,
       confirmadas = conf,
       stats = Boruta::attStats(b)[order(-Boruta::attStats(b)$meanImp),
                                   c("meanImp", "decision")])
}
