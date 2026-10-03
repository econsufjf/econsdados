<div align="center">

<img src="../../assets/wordmark.svg" alt="EconsDados" height="60"/>

# RAIS

**Relação Anual de Informações Sociais — registro administrativo de todos os vínculos empregatícios formais no Brasil (1985–2025)**

![Econs UFJF](https://img.shields.io/badge/Econs-UFJF-1e4a8a?style=flat-square)
![Fonte](https://img.shields.io/badge/Fonte-MTE-5a6070?style=flat-square)
![Anos](https://img.shields.io/badge/Anos-1985–2025-c9a84c?style=flat-square)
![Status](https://img.shields.io/badge/Status-Harmoniza%C3%A7%C3%A3o%20em%20andamento-f9a825?style=flat-square)

</div>

---

## O que é

A RAIS é o registro administrativo do Ministério do Trabalho e Emprego preenchido anualmente por todo estabelecimento com empregados formais no Brasil. Cada linha da base de **vínculos** é um vínculo empregatício (uma pessoa, num estabelecimento, num ano) — com informações sobre o trabalhador (sexo, idade, raça/cor, escolaridade), a ocupação e atividade econômica (CBO, CNAE), o vínculo em si (admissão, desligamento, tempo de emprego) e a remuneração (mensal e de dezembro). Existe também uma base de **estabelecimentos**, um registro por estabelecimento/ano, com porte, natureza jurídica e quantidade de vínculos.

> [!NOTE]
> A RAIS **não é amostra** — é o universo dos vínculos formais declarados. Não captura informalidade.

---

## Cobertura

| | |
|---|---|
| **Anos disponíveis** | 1985–2025 |
| **Anos harmonizados** (nomes de variável + tipo numérico) | 2018 — os demais estão em reprocessamento, ver [status](#status-da-harmonização) |
| **Periodicidade** | Anual |
| **Nível geográfico** | Vínculo / Estabelecimento — agregável a Município, UF, Brasil |
| **Fonte** | [FTP do MTE — microdados RAIS](ftp://ftp.mtps.gov.br/pdet/microdados/RAIS/) |

**Arquivos faltando ou indisponíveis na própria fonte** (não é falha nossa — confirmado com múltiplas tentativas de download, inclusive testando ferramentas diferentes): **SP 1986** (cópia corrompida no FTP do MTE), **RJ 1996**, **MA 1985**, **PA 1986**, **Estabelecimentos 2002–2006**.

---

## O problema: inconsistências ao longo do tempo

A fonte nunca manteve um layout único ao longo dos 40 anos da série, e isso nunca foi documentado de forma centralizada pelo MTE:

- **Mudança de granularidade dos arquivos**: até 2017, um arquivo por **estado** (26–29 arquivos/ano); a partir de 2018, um arquivo por **região** (7–8 arquivos/ano). As duas eras convivem na mesma fonte sem aviso.
- **Nomes de variável diferentes a cada ano** — às vezes até dentro do mesmo ano: em 2018, a região Nordeste chegou com os cabeçalhos em português completo (`Causa_Afastamento_1`) enquanto as outras regiões do mesmo ano vieram no padrão de código do MTE (`causaafastamento1`).
- **Coluna duplicada sem nome**: o cabeçalho da fonte repete "Tipo Estab" duas vezes (uma com código numérico, outra com o texto "CNPJ"/"CEI") — a segunda perde o nome na importação, virando algo como `v43` (posição varia por ano).
- **Valor-lixo de transcrição espalhado em colunas categóricas antigas** — um resíduo tipo `"{ñ"` aparece em até 85% das linhas de algumas colunas em anos antigos (ex: 1985), provavelmente herdado da digitação original em papel.
- **Downloads corrompidos silenciosamente**: uma auditoria em 29/09/2026 testando a integridade de ~980 arquivos `.7z` já baixados achou 54 corrompidos — mesmo tamanho em bytes do arquivo real, conteúdo embaralhado. `import delimited` de um `.7z` corrompido não dá erro, só produz linhas com valores duplicados/deslocados.

> [!WARNING]
> Sem harmonização, uma mesma variável pode ter nomes diferentes em anos ou regiões diferentes, e um download corrompido pode entrar na análise sem nenhum aviso. Usar a série histórica sem tratamento gera comparações erradas silenciosamente.

---

## A solução: harmonização

**Checagem de integridade** — todo `.7z` baixado da fonte é testado (`7z t`, verificação de CRC) antes de ser processado; se vier corrompido, o processo tenta baixar de novo uma vez e, se persistir, pula esse arquivo com aviso em vez de gerar dado incompleto.

**Harmonização de nomes** — um dicionário (nome-como-a-fonte-entrega → nome-canônico) é aplicado na importação. Dois dicionários separados, porque vínculos e estabelecimentos têm colunas bem diferentes — ver a tabela completa em [`dicionario_vinculos.csv`](dicionario_vinculos.csv) e [`dicionario_estabelecimentos.csv`](dicionario_estabelecimentos.csv) (anexados a este README). Um resumo por categoria está na seção [Principais variáveis](#principais-variáveis) abaixo.

**Conversão de tipo** — depois de renomeada, toda coluna é convertida para numérico quando possível. A regra é "forçar, exceto o que sabemos que é texto de verdade" (hoje só `tipo_estab_nome`, que guarda o texto "CNPJ"/"CEI"): valores que não convertem — códigos de "não aplicável", resíduos de transcrição, etc. — viram ausente (`NA`) em vez de bloquear a coluna inteira ou se misturar com códigos reais.

> [!TIP]
> Diferente de outras bases do laboratório, a RAIS **não mantém um arquivo "bruto" separado do harmonizado** — a harmonização acontece na própria importação, e só o resultado final (nomes e tipos corrigidos, valores nunca alterados) é guardado. A base tem centenas de arquivos por estado/região/ano ao longo de 40 anos; manter as duas versões lado a lado dobraria um volume já grande sem necessidade — o dado bruto original pode sempre ser rebaixado da fonte, já que nada no valor é alterado, só nome e tipo da coluna.

**Estrutura dos arquivos:**

```
Bases/
├── 1985/
│   ├── AC1985.fst          ← um arquivo por estado (formato até 2017)
│   ├── AL1985.fst
│   └── ...
├── 2018/
│   ├── RAIS_VINC_PUB_SUL.fst   ← um arquivo por região (formato 2018+)
│   ├── RAIS_ESTAB_PUB.fst      ← base de estabelecimentos
│   └── ...
```

### Status da harmonização

A checagem de integridade e a harmonização de nomes/tipos foram implementadas e testadas de ponta a ponta em **2018** (8 arquivos, nenhuma coluna sem correspondência no dicionário). Os demais anos (1985–2017, 2019–2025) ainda têm os nomes de coluna originais da fonte — o reprocessamento está em andamento. Esta seção será atualizada conforme cada ano for reprocessado.

---

## Principais variáveis

Nomes já harmonizados (iguais em todos os anos, quando o reprocessamento daquele ano estiver concluído):

| Categoria | Variável | Descrição |
|---|---|---|
| Identificação | `municipio` | Código do município do estabelecimento |
| Identificação | `municipio_trab` | Código do município de trabalho (quando diferente) |
| Identificação | `uf` | Unidade da Federação *(base de estabelecimentos)* |
| Trabalhador | `sexo` | Sexo do trabalhador |
| Trabalhador | `idade` | Idade |
| Trabalhador | `raca_cor` | Raça/cor |
| Trabalhador | `escolaridade` | Escolaridade |
| Trabalhador | `nacionalidade` | Nacionalidade |
| Ocupação/Atividade | `cbo2002` | Ocupação (CBO 2002) |
| Ocupação/Atividade | `cnae20_classe` | Atividade econômica (CNAE 2.0, classe) |
| Ocupação/Atividade | `cnae20_subclasse` | Atividade econômica (CNAE 2.0, subclasse) |
| Vínculo | `vinculo_ativo_3112` | Vínculo ativo em 31/12 |
| Vínculo | `tipo_admissao` | Tipo de admissão |
| Vínculo | `motivo_deslig` | Motivo do desligamento |
| Vínculo | `tempo_emprego` | Tempo de emprego |
| Remuneração | `rem_dez_nom` | Remuneração de dezembro (valor nominal) — ⚠️ sem remuneração é `0` até 2022 e `NA` desde 2023 ([ver aviso](#observações-e-limitações)) |
| Remuneração | `rem_media_nom` | Remuneração média no ano (valor nominal) |
| Remuneração | `salario_contratual` | Salário contratual |
| Estabelecimento | `tipo_estab` | Tipo de estabelecimento (código: CNPJ/CEI) |
| Estabelecimento | `tamanho_estab` | Porte do estabelecimento |
| Estabelecimento | `natureza_juridica` | Natureza jurídica |

<details>
<summary>Ver lista completa de variáveis (68 na base de vínculos, 25 na de estabelecimentos)</summary>

A base de vínculos tem campos adicionais de localização (bairros de SP/Fortaleza/RJ, distritos de SP, regiões administrativas do DF — só preenchidos nesses municípios específicos), afastamento (até 3 causas registradas), remuneração mensal (janeiro a novembro, além de dezembro) e indicadores de vínculo intermitente/parcial. A lista completa, com o nome original de cada ano mapeado pro nome canônico, está em [`dicionario_vinculos.csv`](dicionario_vinculos.csv) e [`dicionario_estabelecimentos.csv`](dicionario_estabelecimentos.csv).

</details>

---

## Observações e limitações

> [!WARNING]
> **Remuneração de dezembro em valor nominal (`rem_dez_nom`): o tratamento de quem não tem remuneração no mês muda em 2023.** Até 2022, esses vínculos aparecem com `rem_dez_nom = 0`; de 2023 em diante, aparecem com `rem_dez_nom` ausente (`NA`). Não é erro da base — é como o MTE passou a entregar o campo —, mas torna a média incomparável entre os dois períodos: os zeros entram na média até 2022 e, a partir de 2023, ficam de fora.
>
> | | 2018–2022 | 2023 em diante |
> |---|---|---|
> | `rem_dez_nom` de quem não tem remuneração em dezembro | `0` | `NA` |
> | `rem_dez_sm`, `rem_media_nom`, `rem_media_sm` | `0` | `0` (sem mudança) |
> | Parcela dos vínculos nessa situação | 29,6% (2018) a 35,9% (2022) | 38,6% (2023) a 41,8% (2025) |
>
> Para comparar médias de `rem_dez_nom` entre os dois períodos, use o mesmo critério nos dois — por exemplo, tratar `NA` como `0` a partir de 2023, ou excluir os zeros dos anos anteriores. `rem_dez_sm` (em salários mínimos) não tem essa quebra e identifica os mesmos casos em todos os anos (`rem_dez_sm == 0`). Os anos anteriores a 2018 ainda não foram conferidos para `rem_dez_nom` (a variável existe a partir de 1999).

> [!NOTE]
> - A harmonização de nomes/tipos só está concluída para **2018** — os demais anos ainda estão no formato original da fonte (ver [status](#status-da-harmonização)).
> - O dicionário de harmonização foi construído observando principalmente 2018 e 2025; é esperado que apareçam nomes de coluna sem correspondência ao reprocessar outros anos — o processo de importação avisa quando isso acontece, em vez de falhar silenciosamente, e o dicionário é atualizado conforme necessário.
> - `SP 1986` está indisponível — a cópia no FTP do MTE está corrompida (confirmado com múltiplas tentativas de download e ferramentas diferentes).

---

## Referências

- 🌐 [FTP de microdados — MTE](ftp://ftp.mtps.gov.br/pdet/microdados/RAIS/)
- 📄 [`dicionario_vinculos.csv`](dicionario_vinculos.csv) — mapeamento completo nome-original → nome-canônico, base de vínculos
- 📄 [`dicionario_estabelecimentos.csv`](dicionario_estabelecimentos.csv) — mapeamento completo, base de estabelecimentos

---

<div align="center">
<sub>Econs — Laboratório de Estudos Econômicos · UFJF &nbsp;|&nbsp; <a href="https://econsufjf.github.io">econsufjf.github.io</a></sub>
</div>
