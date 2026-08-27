<div align="center">

<img src="../../assets/wordmark.svg" alt="EconsDados" height="60"/>

# SAEB

**Microdados do Sistema de Avaliação da Educação Básica — proficiência de alunos do EF e EM (1995–2023)**

![Econs UFJF](https://img.shields.io/badge/Econs-UFJF-1e4a8a?style=flat-square)
![Fonte](https://img.shields.io/badge/Fonte-INEP-5a6070?style=flat-square)
![Anos](https://img.shields.io/badge/Anos-1995–2023-c9a84c?style=flat-square)
![Status](https://img.shields.io/badge/Status-Harmonizada-2e7d32?style=flat-square)

</div>

---

## O que é

O SAEB é o principal sistema de avaliação em larga escala da educação básica brasileira, conduzido pelo INEP. Cada linha dos microdados representa um **aluno** avaliado em uma determinada disciplina. O banco registra a proficiência na Escala SAEB, características do aluno, da escola, do professor e do diretor, além de pesos amostrais para estimativas representativas.

---

## Cobertura

| | |
|---|---|
| **Anos disponíveis** | 1995, 1997, 1999, 2001, 2003, 2005, 2007, 2009, 2011, 2013, 2015, 2017, 2019, 2021, 2023 |
| **Anos harmonizados** | 1995–2023 (todas as edições) |
| **Periodicidade** | Bienal |
| **Séries avaliadas** | 5º ano EF · 9º ano EF · 3º ano EM |
| **Disciplinas** | Língua Portuguesa · Matemática |
| **Nível geográfico** | Aluno / Escola / Município / UF / Brasil |
| **Fonte** | [Portal de Microdados — INEP](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/saeb) |

---

## O problema: inconsistências ao longo do tempo

O SAEB passou por cinco reformulações estruturais entre 1995 e 2023, alterando nomes de variáveis, codificações, número de arquivos por edição e até a nomenclatura das séries avaliadas.

> [!WARNING]
> Nomes de variáveis iguais podem significar coisas diferentes entre períodos — e variáveis equivalentes frequentemente têm nomes distintos. Usar os arquivos brutos diretamente para série histórica exige tratamento cuidadoso.

As principais quebras de série são:

| Período | Característica |
|---------|---------------|
| 1995–2005 | Um arquivo por disciplina × série; proficiência em `PROFIC` / `PROFIC_SAE`; rede em `REDE` (1=pública, 2=privada) |
| 2007–2009 | Disciplinas LP e MT no mesmo arquivo; peso amostral separado por disciplina (`PESO_ALUNO_LP` / `PESO_ALUNO_MT`) |
| 2011 | Variáveis em **minúsculas**; proficiência em arquivo separado (`TS_RESULTADO_ALUNO`); peso único para LP e MT |
| 2013–2017 | Variáveis em maiúsculas; `ID_DEPENDENCIA_ADM` substitui `IN_PUBLICA` |
| 2019–2023 | Retorno de `IN_PUBLICA`; arquivo de 3º ano EM passa a cobrir 3ª e 4ª séries (`34EM`) |

A mudança de nomenclatura de séries a partir de 2011 (Lei nº 11.274/2006 — EF de 9 anos) também afeta a identificação dos grupos ao longo do tempo:

| Nomenclatura histórica | Nomenclatura atual |
|------------------------|-------------------|
| 4ª série EF | 5º ano EF |
| 8ª série EF | 9º ano EF |

---

## A solução: harmonização

O painel harmonizado empilha todas as edições em formato longo (uma linha por aluno × disciplina) com variáveis padronizadas entre os períodos.

**Estrutura dos arquivos:**

```
Bases/
├── <ano>/
│   └── SAEB_<serie>_<ano>.dta    ← importado do bruto (Stata)
└── painel_saeb_harmonizado.rds   ← painel longo harmonizado (R)
```

> [!TIP]
> Use `painel_saeb_harmonizado.rds` para análises em série histórica. Os `.dta` por ano servem para análises cross-section ou para reprocessar anos específicos.

---

## Principais variáveis

| Categoria | Variável | Descrição |
|---|---|---|
| Temporal | `ano` | Edição do SAEB |
| Série | `serie` | `"5EF"` · `"9EF"` · `"3EM"` |
| Disciplina | `disciplina` | `"LP"` · `"MT"` |
| Identificação | `id_aluno` | Identificador do aluno |
| Identificação | `id_escola` | Código da escola (disponível a partir de 2007) |
| Identificação | `id_municipio` | Código do município (disponível a partir de 2007) |
| Identificação | `id_uf` | Código da UF |
| Rede | `in_publica` | 1 = pública · 0 = privada |
| Rede | `dep_adm` | 1=federal · 2=estadual · 3=municipal · 4=privada (disponível em 2011–2017) |
| Localização | `localizacao` | 1 = urbana · 2 = rural |
| Peso | `peso` | Peso amostral (disciplina-específico quando disponível) |
| Resultado | `proficiencia` | Proficiência na Escala SAEB |

<details>
<summary>Cobertura de variáveis por período</summary>

| Variável | 1995–2005 | 2007–2009 | 2011 | 2013–2017 | 2019–2023 |
|----------|:---------:|:---------:|:----:|:---------:|:---------:|
| `proficiencia` | ✓ | ✓ | ✓ | ✓ | ✓ |
| `in_publica` | ✓ | ✓ | ✓ | ✓ | ✓ |
| `dep_adm` | — | — | ✓ | ✓ | — |
| `peso` | ✓ | ✓ | ✓ | ✓ | ✓ |
| `id_escola` | — | ✓ | ✓ | ✓ | ✓ |
| `id_municipio` | — | ✓ | ✓ | ✓ | ✓ |
| `id_uf` | ✓ | ✓ | ✓ | ✓ | ✓ |
| `id_regiao` | ✓ | ✓ | ✓ | ✓ | ✓ |
| `localizacao` | ✓ | ✓ | ✓ | ✓ | ✓ |
| `id_turno` | — | — | ✓ | ✓ | — |

</details>

---

## Observações e limitações

> [!NOTE]
> - `id_regiao` ausente em 2001; `id_uf` em formato character em 2005 (convertido para int no painel).
> - Em 2017, o 3º EM possui dois arquivos: amostra ampliada (`_AG`) e por escola (`_ESC`). O painel usa `_AG`.
> - Em 2019–2023, o arquivo `34EM` cobre 3ª e 4ª séries do EM; mantido como `"3EM"` no painel.
> - `id_turno` disponível apenas em 2011–2017.
> - Peso amostral único para LP e MT em 2011 (nas demais edições a partir de 2007 os pesos são disciplina-específicos).
> - A partir de 2019 o SAEB passou a avaliar também o **2º ano do EF** (LP e MT). Essa série **não está incluída no painel harmonizado**, que cobre apenas as três séries com histórico desde 1995 (5EF, 9EF, 3EM).

---

## Referências

- 📄 [Dicionário de variáveis — INEP](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/saeb)
- 🌐 [Portal de Microdados — INEP](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/saeb)
- 📑 [Nota Técnica SAEB 2023](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/saeb)

---

<div align="center">
<sub>Econs — Laboratório de Estudos Econômicos · UFJF &nbsp;|&nbsp; <a href="https://econsufjf.github.io">econsufjf.github.io</a></sub>
</div>
