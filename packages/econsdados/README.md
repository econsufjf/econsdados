<div align="center">

<img src="../../assets/wordmark.svg" alt="EconsDados" height="60"/>

# Pacote R `econsdados`

**Carrega as bases de dados tratadas do Econs direto do servidor do laboratório**

![Econs UFJF](https://img.shields.io/badge/Econs-UFJF-1e4a8a?style=flat-square)
![Versão](https://img.shields.io/badge/Versão-0.0.1-c9a84c?style=flat-square)

</div>

---

## Requisitos

- Estar na **rede da UFJF** (o servidor não é acessível de fora)
- **Windows**
- **Usuário e senha** do servidor do Econs — peça ao laboratório

---

## Instalação

```r
install.packages("remotes")   # se ainda não tiver
remotes::install_github("econsufjf/econsdados", subdir = "packages/econsdados")
```

---

## Primeiro uso: conectar ao servidor

```r
library(econsdados)
conectar_econs()
```

O R pede o usuário no console e abre uma janela para a senha. O login fica salvo no Gerenciador de Credenciais do Windows — **basta rodar uma vez em cada computador**. A senha não fica gravada em nenhum script.

> [!NOTE]
> Se alguma função disser *"Sem acesso ao servidor do Econs"*, confira se está na rede da UFJF e rode `conectar_econs()` de novo.

---

## Funções

### PNADC

| Função | O que faz |
|---|---|
| `pnadc_disponivel()` | Lista os anos e períodos disponíveis no servidor |
| `carregar_pnadc(ano, trimestre, colunas)` | Divulgação trimestral (pesquisa básica) |
| `carregar_pnadc_anual(ano, visita, trimestre, colunas)` | Divulgação anual (pesquisas suplementares), por visita **ou** por trimestre |

```r
pnadc_disponivel()

# Um trimestre
pnad <- carregar_pnadc(2026, trimestre = 2)

# Vários trimestres são empilhados num único data.frame
pnad <- carregar_pnadc(2025, trimestre = 1:4)

# Só algumas colunas — bem mais rápido e leve (maiúsculas ou minúsculas)
pnad <- carregar_pnadc(2025, trimestre = 1:4, colunas = c("UF", "V1028", "VD4002"))

# Anual: por visita OU por trimestre, conforme o tema (ver README da PNADC)
pnad <- carregar_pnadc_anual(2024, visita = 1)
pnad <- carregar_pnadc_anual(2024, trimestre = 2)
```

> [!WARNING]
> O peso amostral muda conforme o arquivo: **`V1028`** na divulgação trimestral e na anual por trimestre, **`V1032`** na anual por visita.

> [!TIP]
> Um ano completo da PNADC ocupa cerca de 2 GB de memória. Sempre que possível, use `colunas` para carregar só o que a análise precisa.

Documentação da base: [README da PNADC](../../ibge/pnadc/README.md).

### Outras bases

RAIS e demais bases: em breve.

---

<div align="center">
<sub>Econs — Laboratório de Estudos Econômicos · UFJF &nbsp;|&nbsp; <a href="https://econsufjf.github.io">econsufjf.github.io</a></sub>
</div>
