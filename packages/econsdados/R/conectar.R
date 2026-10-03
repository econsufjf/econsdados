servidor_econs <- "10.10.250.20"
pasta_econs <- paste0("//", servidor_econs, "/FTPECONS")

#' Conecta este computador ao servidor do Econs
#'
#' Salva usuário e senha do servidor no Gerenciador de Credenciais do Windows.
#' Basta rodar uma vez por computador; depois o acesso é automático.
#' Só funciona dentro da rede da UFJF.
#'
#' @param usuario Usuário do servidor. Se omitido, é perguntado no console.
#' @export
conectar_econs <- function(usuario = NULL) {
  if (.Platform$OS.type != "windows") stop("conectar_econs() só funciona no Windows.")

  if (dir.exists(pasta_econs)) {
    message("Este computador já acessa o servidor do Econs.")
    return(invisible(TRUE))
  }

  if (is.null(usuario)) usuario <- readline("Usuário do servidor Econs: ")
  senha <- askpass::askpass("Senha do servidor Econs:")
  if (is.null(senha)) stop("Cancelado.")

  # remove credencial antiga (se houver) e grava a nova
  system2("cmdkey", paste0("/delete:", servidor_econs), stdout = FALSE, stderr = FALSE)
  system2("cmdkey", c(paste0("/add:", servidor_econs), paste0("/user:", usuario),
                      paste0("/pass:", senha)), stdout = FALSE, stderr = FALSE)

  if (dir.exists(pasta_econs)) {
    message("Conectado. Não precisa rodar de novo neste computador.")
    return(invisible(TRUE))
  }

  system2("cmdkey", paste0("/delete:", servidor_econs), stdout = FALSE, stderr = FALSE)
  stop("Não foi possível acessar ", pasta_econs, ". Confira usuário e senha.")
}

# Erro claro quando o servidor não está acessível
checar_conexao <- function() {
  if (!dir.exists(pasta_econs)) {
    stop("Sem acesso ao servidor do Econs (", pasta_econs, ").\n",
         "Confira se está na rede da UFJF e rode conectar_econs().", call. = FALSE)
  }
}
