<div align="center">

<img src="assets/wordmark.svg" alt="EconsDados" height="60"/>

**Bases de dados públicas organizadas, documentadas e harmonizadas pelo laboratório**

[![Site](https://img.shields.io/badge/Site-econsufjf.github.io-1e4a8a?style=flat-square)](https://econsufjf.github.io/econsdados)
[![Licença](https://img.shields.io/badge/Licença-CC%20BY%204.0-c9a84c?style=flat-square)](https://creativecommons.org/licenses/by/4.0/)

</div>

---

## O que é este repositório

O **EconsDados** reúne bases de dados públicas utilizadas nas pesquisas do ECONS — Laboratório de Estudos Econômicos da UFJF. Para cada base você encontra:

- **Documentação** — o que é a base, anos disponíveis e como interpretá-la corretamente
- **Harmonização** — o que foi feito para compatibilizar os dados ao longo do tempo
- **Principais variáveis** — dicionário resumido com as variáveis mais usadas

Os dados brutos **não estão neste repositório** — são grandes demais para o GitHub. Cada README indica onde baixá-los e como reproduzir o processamento.

---

## Organização

```
econsdados/
├── educacao/
│   └── saeb/          ← Avaliação da Educação Básica (INEP)
├── ibge/
│   └── pnadc/         ← Pesquisa Nacional por Amostra de Domicílios Contínua (IBGE)
├── saude/
│   ├── sinasc/        ← Nascidos Vivos (DataSUS)
│   └── sihsus/        ← Internações Hospitalares (DataSUS)
└── assets/
    └── wordmark.svg
```

---

## Bases disponíveis

| Base | Tema | Anos harmonizados | Status |
|---|---|---|---|
| [SAEB](educacao/saeb/README.md) | Educação | 1995–2023 | ✅ Disponível |
| [SINASC](saude/sinasc/README.md) | Saúde | 1996–2024 | ✅ Disponível |
| [PNADC](ibge/pnadc/README.md) | IBGE | 2012–2026 | ✅ Disponível |
| SIHSUS | Saúde | — | 🔄 Em preparação |
| RAIS | Mercado de trabalho | — | 🔄 Em preparação |
| CAGED | Mercado de trabalho | — | 🔄 Em preparação |

---

<div align="center">
<sub>Econs — Laboratório de Estudos Econômicos · UFJF &nbsp;|&nbsp; <a href="https://econsufjf.github.io">econsufjf.github.io</a></sub>
</div>
