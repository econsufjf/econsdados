# SIA-SUS — Sistema de Informações Ambulatoriais do SUS

## O que é

Registra a **produção ambulatorial** financiada pelo SUS: consultas, exames, procedimentos de baixa e média complexidade, terapias, pequenas cirurgias, etc. É o equivalente ambulatorial do SIH-SUS (que cobre internações).

## Unidade de observação

Varia por arquivo. O mais comum, **PA (Produção Ambulatorial)**, tem uma linha por **procedimento registrado** (não necessariamente por paciente ou por atendimento) — um mesmo atendimento pode gerar múltiplas linhas se envolver mais de um procedimento faturável. Isso é diferente do SIH-SUS, onde a linha é a internação inteira.

## Tipos de arquivo

| Arquivo | Conteúdo |
|---|---|
| **PA** (Produção Ambulatorial) | Base principal — procedimentos realizados e faturados |
| **BI** (Boletim de Produção Individualizada) | Produção individualizada por profissional/paciente (cobertura mais recente e mais completa em identificação) |
| **AB** | Atenção básica (dados de PSF/ESF antes do e-SUS APS) |
| **AD** | Procedimentos de agravos/doenças específicas |
| **AM** | Medicamentos excepcionais/alto custo |
| **AQ** | Quimioterapia |
| **AR** | Radioterapia |
| **ATD** | Atendimento (dados administrativos do atendimento) |
| **PS** | Psicossocial (CAPS) |
| **SAD** | Atenção domiciliar |

Na prática, para a maioria dos usos em pesquisa aplicada, **PA** é o ponto de partida.

## Principais variáveis (arquivo PA)

**Identificação e localização**
- `PA_MUNPCN` — município de residência do paciente
- `PA_CODUNI` — código do estabelecimento (CNES)
- `PA_UFMUN` — município do estabelecimento

**Procedimento**
- `PA_PROC_ID` — código do procedimento (tabela SIGTAP)
- `PA_CBOCOD` — ocupação do profissional que realizou (CBO)
- `PA_QTDPRO` — quantidade produzida/aprovada
- `PA_VALPRO` / `PA_VALAPR` — valor apresentado / aprovado

**Clínico**
- `PA_CIDPRI` — CID principal (nem sempre bem preenchido, cobertura pior que no SIH)

**Demográfico**
- `PA_IDADE`, `PA_SEXO`, `PA_RACACOR`

**Temporal**
- `PA_CMP` — competência (ano/mês de referência)

## Cuidados metodológicos

1. **Contagem de procedimentos ≠ contagem de pacientes/atendimentos**: um único atendimento pode gerar várias linhas (ex: consulta + exame + curativo). Agregações diretas de "número de linhas" superestimam volume de atendimento se o objetivo é medir acesso ou demanda por pessoa.

2. **Identificação individual limitada no PA**: o arquivo PA tradicional não tem identificador confiável de paciente ao longo do tempo. O **BI (Boletim de Produção Individualizada)** tem melhor granularidade nesse sentido, mas cobertura/qualidade variam por período e município — verificar disponibilidade antes de desenhar o projeto.

3. **Diagnóstico (CID) mal preenchido**: ao contrário do SIH, o preenchimento de CID no ambulatorial é historicamente mais fraco e inconsistente — não é confiável como variável principal de análise clínica sem checagem cuidadosa.

4. **Sub-registro de atenção básica**: procedimentos de atenção primária são melhor capturados pelo **e-SUS APS** (que substituiu o SIAB) do que pelo SIA/PA — se o foco for APS, considere cruzar ou preferir essa outra base.

5. **Mudanças de tabela SIGTAP**: assim como no SIH, os códigos de procedimento são atualizados periodicamente — séries longas exigem harmonização de códigos.

6. **Teto financeiro/orçamentário influencia registro**: em alguns municípios, a produção registrada reflete tanto demanda real quanto limites orçamentários/pactuação (PPI), o que pode distorcer comparações entre municípios com tetos financeiros muito diferentes.

7. **Defasagem de processamento**: como no SIH, os últimos meses disponíveis podem estar incompletos por atraso no fechamento da competência.

## Acesso

- **TABNET**: tabulações agregadas de produção ambulatorial por procedimento/CID/UF/ano
- **FTP DataSUS** (`ftp://ftp.datasus.gov.br/dissemin/publicos/SIASUS/`): microdados em `.dbc`, organizados por UF/ano/mês
- **PySUS** (Python): `from pysus.online_data import SIA` — importa e descompacta o `.dbc`
