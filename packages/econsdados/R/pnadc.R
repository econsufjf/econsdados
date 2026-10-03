pasta_pnadc <- file.path(pasta_econs, "IBGE", "PNADC")

# Índice dos arquivos da PNADC no servidor: tipo, ano, periodo, arquivo
indice_pnadc <- function() {
  checar_conexao()
  padroes <- c(
    "trimestral"        = "^Trimestral/\\d{4}/PNADC_(\\d{2})(\\d{4})\\.fst$",
    "anual - visita"    = "^Anual - visita/\\d{4}/PNADC_anual_visita(\\d)_(\\d{4})\\.fst$",
    "anual - trimestre" = "^Anual - trimestre/\\d{4}/PNADC_anual_trimestre(\\d)_(\\d{4})\\.fst$"
  )
  arquivos <- list.files(pasta_pnadc, pattern = "\\.fst$", recursive = TRUE)
  do.call(rbind, lapply(names(padroes), function(tipo) {
    a <- grep(padroes[[tipo]], arquivos, value = TRUE)
    data.frame(tipo = rep(tipo, length(a)),
               ano = as.integer(sub(padroes[[tipo]], "\\2", a)),
               periodo = as.integer(sub(padroes[[tipo]], "\\1", a)),
               arquivo = file.path(pasta_pnadc, a))
  }))
}

#' Períodos da PNADC disponíveis no servidor
#'
#' @return data.frame com o tipo de arquivo (trimestral, anual por visita,
#'   anual por trimestre), o ano e os períodos disponíveis.
#' @export
pnadc_disponivel <- function() {
  idx <- indice_pnadc()
  idx <- idx[order(idx$tipo, idx$ano, idx$periodo), ]
  aggregate(periodo ~ tipo + ano, idx, function(p) paste(p, collapse = ", "))
}

#' Carrega a PNADC trimestral
#'
#' @param ano Ano (um só).
#' @param trimestre Trimestre(s), de 1 a 4. Vários trimestres são empilhados.
#' @param colunas Colunas a carregar (maiúsculas ou minúsculas). `NULL` carrega todas.
#' @return data.frame
#' @examples
#' \dontrun{
#' pnad <- carregar_pnadc(2025, trimestre = 1)
#' pnad <- carregar_pnadc(2025, trimestre = 1:4, colunas = c("UF", "V1028", "VD4002"))
#' }
#' @export
carregar_pnadc <- function(ano, trimestre, colunas = NULL) {
  if (missing(trimestre)) stop("Informe o trimestre (ex.: trimestre = 1 ou trimestre = 1:4).")
  stopifnot(length(ano) == 1)
  trimestre <- sort(unique(trimestre))

  arquivos <- arquivos_periodo("trimestral", ano, trimestre, "trimestre")

  # ano completo: usa o arquivo já empilhado, se existir (mais rápido)
  if (identical(trimestre, 1:4)) {
    anual <- file.path(pasta_pnadc, "Trimestral", ano, paste0("PNADC", ano, "_T1aT4.fst"))
    if (file.exists(anual)) arquivos <- anual
  }
  ler_fst(arquivos, colunas)
}

#' Carrega a PNADC anual (pesquisas suplementares)
#'
#' A divulgação anual vem separada por visita ou por trimestre, conforme o
#' tema. Informe um dos dois.
#'
#' @param ano Ano (um só).
#' @param visita Visita (1 a 5).
#' @param trimestre Trimestre (1 a 4).
#' @param colunas Colunas a carregar (maiúsculas ou minúsculas). `NULL` carrega todas.
#' @return data.frame
#' @examples
#' \dontrun{
#' pnad <- carregar_pnadc_anual(2024, visita = 1)
#' pnad <- carregar_pnadc_anual(2024, trimestre = 2)
#' }
#' @export
carregar_pnadc_anual <- function(ano, visita = NULL, trimestre = NULL, colunas = NULL) {
  if (is.null(visita) == is.null(trimestre)) {
    stop("Informe visita OU trimestre (ex.: visita = 1 ou trimestre = 2).")
  }
  stopifnot(length(ano) == 1)
  if (!is.null(visita)) {
    arquivos <- arquivos_periodo("anual - visita", ano, visita, "visita")
  } else {
    arquivos <- arquivos_periodo("anual - trimestre", ano, trimestre, "trimestre")
  }
  ler_fst(arquivos, colunas)
}

# Arquivos de um tipo/ano/período; erro com os períodos disponíveis se faltar algum
arquivos_periodo <- function(tipo, ano, periodos, nome_periodo) {
  idx <- indice_pnadc()
  idx <- idx[idx$tipo == tipo, ]
  anos <- idx$ano
  idx <- idx[idx$ano == ano, ]
  if (!nrow(idx)) {
    stop("PNADC ", tipo, ": ano ", ano, " não disponível. Anos disponíveis: ",
         min(anos), "-", max(anos), ".")
  }
  faltam <- setdiff(periodos, idx$periodo)
  if (length(faltam)) {
    stop("PNADC ", tipo, " ", ano, ": ", nome_periodo, " ", paste(faltam, collapse = ", "),
         " não disponível. Disponíveis: ", paste(sort(idx$periodo), collapse = ", "), ".")
  }
  idx$arquivo[match(periodos, idx$periodo)]
}

# Lê um ou mais .fst (empilhando) só com as colunas pedidas.
# Os nomes de `colunas` são comparados sem diferenciar maiúsculas/minúsculas.
ler_fst <- function(arquivos, colunas = NULL) {
  if (!is.null(colunas)) {
    existentes <- fst::metadata_fst(arquivos[1])$columnNames
    pos <- match(tolower(colunas), tolower(existentes))
    if (anyNA(pos)) {
      stop("Colunas não encontradas: ", paste(colunas[is.na(pos)], collapse = ", "))
    }
    colunas <- existentes[pos]
  }
  if (length(arquivos) == 1) return(fst::read_fst(arquivos, columns = colunas))
  d <- data.table::rbindlist(lapply(arquivos, fst::read_fst, columns = colunas))
  data.table::setDF(d)
  d
}
