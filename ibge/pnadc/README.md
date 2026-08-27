<div align="center">

<img src="../../assets/wordmark.svg" alt="EconsDados" height="60"/>

# PNADC

**Pesquisa Nacional por Amostra de Domicílios Contínua — levantamento trimestral do IBGE sobre mercado de trabalho, rendimento e características da população brasileira**

![Econs UFJF](https://img.shields.io/badge/Econs-UFJF-1e4a8a?style=flat-square)
![Fonte](https://img.shields.io/badge/Fonte-IBGE-5a6070?style=flat-square)
![Anos](https://img.shields.io/badge/Anos-2012–2026-c9a84c?style=flat-square)
![Status](https://img.shields.io/badge/Status-Disponível-2e7d32?style=flat-square)

</div>

---

## O que é

A PNADC é o levantamento domiciliar por amostra do IBGE que substituiu a antiga PNAD anual a partir de 2012, com divulgação trimestral. Cada linha da base é uma **pessoa entrevistada em um domicílio**, com informações sobre trabalho, rendimento, educação e demais características socioeconômicas. É a principal fonte de indicadores de desemprego, informalidade e rendimento do trabalho no Brasil.

---

## Cobertura

| | |
|---|---|
| **Anos disponíveis** | 2012–2026 (série corrente do IBGE) |
| **Cobertura completa** | 2012–2026 · 2026 com apenas 1º e 2º trimestres publicados até o momento |
| **Periodicidade** | Trimestral |
| **Nível geográfico** | Brasil / UF |
| **Fonte** | [IBGE — PNADC, microdados](https://www.ibge.gov.br/estatisticas/sociais/trabalho/9171-pesquisa-nacional-por-amostra-de-domicilios-continua-mensal.html) |

---

## A solução: importação padronizada

Toda a série é importada por uma rotina única em R, usando o pacote **oficial do IBGE**
[`PNADcIBGE`](https://cran.r-project.org/package=PNADcIBGE), que baixa e lê os
microdados diretamente do FTP oficial já aplicando o dicionário e os labels do IBGE —
garantindo formato e nomenclatura de variáveis consistentes em toda a série histórica.

**Estrutura dos arquivos:**

```
Bases/
├── <ano>/
│   ├── PNADC_0<trim><ano>.dta / .fst        ← um trimestre isolado
│   └── PNADC<ano>_T<min>aT<max>.dta / .fst  ← trimestres disponíveis do ano, empilhados
```

> [!TIP]
> O arquivo empilhado (`PNADC<ano>_T...`) é a forma recomendada de uso quando a análise não precisa distinguir trimestre — já reúne tudo que está disponível daquele ano.

---

## Principais variáveis

| Categoria | Variável | Descrição |
|---|---|---|
| Identificação | `Ano` | Ano de referência |
| Identificação | `Trimestre` | Trimestre de referência |
| Identificação | `UF` | Unidade da Federação |
| Identificação | `UPA` / `V1008` / `V1014` | Compõem a identificação do domicílio no painel |
| Pessoa | `V2007` | Sexo |
| Pessoa | `V2009` | Idade |
| Pessoa | `V2010` | Cor ou raça |
| Trabalho | `VD4002` | Condição de ocupação (ocupado / desocupado) |
| Trabalho | `VD4008` | Posição na ocupação |
| Trabalho | `VD4020` | Rendimento habitual do trabalho principal |
| Peso amostral | `V1028` | Peso do domicílio e das pessoas |

<details>
<summary>Ver lista completa de variáveis</summary>

A base tem centenas de colunas (identificação, características pessoais, trabalho, rendimento e módulos temáticos variáveis por trimestre). Consulte o dicionário oficial do IBGE, disponível junto ao pacote `PNADcIBGE` ou no FTP oficial.

</details>

---

## Observações e limitações

> [!NOTE]
> - **2026** tem apenas o 1º e o 2º trimestres publicados até o momento — série ainda incompleta para esse ano.
> - Os labels das variáveis categóricas seguem o dicionário oficial do IBGE aplicado pelo pacote `PNADcIBGE`, não os rótulos de versões antigas eventualmente encontradas em outras fontes.

---

## Referências

- 📄 [Dicionário de variáveis — IBGE](https://www.ibge.gov.br/estatisticas/sociais/trabalho/9171-pesquisa-nacional-por-amostra-de-domicilios-continua-mensal.html)
- 🌐 [Pacote PNADcIBGE — CRAN](https://cran.r-project.org/package=PNADcIBGE)
- 🌐 [FTP de microdados — IBGE](ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/)

---

<div align="center">
<sub>Econs — Laboratório de Estudos Econômicos · UFJF &nbsp;|&nbsp; <a href="https://econsufjf.github.io">econsufjf.github.io</a></sub>
</div>
