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

## Divulgação Trimestral (indicadores correntes)

Esta é a pesquisa básica da PNADC, investigada trimestralmente em toda a amostra — não os módulos suplementares (ver "Divulgação Anual" abaixo). É a fonte dos indicadores correntes de mercado de trabalho (desemprego, ocupação, rendimento).

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

## Divulgação Anual (pesquisas suplementares)

A amostra da PNADC é rotativa: cada domicílio é entrevistado uma vez por trimestre, por 5 trimestres seguidos (**visitas**), depois sai da amostra. A divulgação Trimestral (acima) é a pesquisa básica, investigada em toda a amostra, todo trimestre. O IBGE também publica uma divulgação **Anual**, com pesquisas **suplementares** sobre temas que não são investigados o tempo todo — Educação, Habitação, Migração, entre outros.

Cada tema suplementar é investigado só numa subamostra específica, definida de uma de duas formas (o IBGE decide qual por tema):

- **Por Visita** — o tema foi investigado nos domicílios que estavam numa visita específica (1ª a 5ª), acumulados ao longo dos trimestres do ano.
- **Por Trimestre** — o tema foi investigado em toda a amostra de um trimestre civil específico (ex: Educação é sempre no 2º trimestre).

Não são duas formas de acessar os mesmos dados — são dois métodos de subamostragem diferentes, e cada tema suplementar usa apenas um deles. O quadro oficial "PNAD Contínua – Pesquisas Suplementares Anuais" (ver referências) indica qual método se aplica a cada tema, em cada ano — resumido abaixo:

**Por Visita:**

| Tema | Visita | Anos |
|---|---|---|
| Características adicionais do mercado de trabalho | 1 | 2012–2019, 2022–2024 |
| Rendimento de outras fontes | 1 (e 5 em alguns anos) | 2012–2025 |
| Características gerais dos moradores | 1 (5 em 2020/2021) | 2012–2025 |
| Habitação | 1 | 2016–2019, 2022–2025 |
| Outras formas de trabalho | 5 | 2016–2019, 2022–2024 |
| Trabalho de crianças e adolescentes | 5 | 2016–2019, 2022–2024 |
| Turismo | 2 | 2019–2021, 2023–2024 |

**Por Trimestre:**

| Tema | Trimestre | Anos |
|---|---|---|
| Educação | 2 | 2016–2019, 2022–2025 |
| TIC (Tecnologia da Informação e Comunicação) | 4 | 2016–2019, 2021–2025 |
| Sensação de segurança | 4 | 2021 |
| Furto e roubo | 4 | 2021 |
| Atenção primária à saúde | 2 | 2022 |
| Pessoas com Deficiência | 3 | 2022 |
| Teletrabalho | 4 | 2022 |
| Trabalho por meio de plataformas digitais | 4 | 2022, 2024 |
| Segurança Alimentar | 4 | 2023, 2024 |
| COVID-19 | 1 | 2023 |

> [!NOTE]
> A base organizada pelo laboratório cobre, por enquanto, apenas a via **por Trimestre**. A via por Visita ainda não foi processada.

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
- 📄 [LEIA-ME oficial — divulgação Anual (Visita vs. Trimestre)](https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/LEIA-ME.pdf)
- 📄 [Quadro de pesquisas suplementares anuais 2012–2025 — IBGE](https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Anual/Microdados/PNADC_Pesquisas_Suplementares_Anuais_20260702.pdf)

---

<div align="center">
<sub>Econs — Laboratório de Estudos Econômicos · UFJF &nbsp;|&nbsp; <a href="https://econsufjf.github.io">econsufjf.github.io</a></sub>
</div>
