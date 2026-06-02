# TechSales Data Pipeline

## 📋 Sobre o Projeto
Pipeline completo de dados de uma distribuidora fictícia 
de tecnologia (TechSales Ltda), cobrindo todas as etapas 
de um projeto real de dados:
OLTP → Stage → DataWarehouse → ETL → BI

## 🏢 Contexto
A TechSales Ltda é uma distribuidora de produtos de 
tecnologia que controlava tudo em planilhas Excel.
O projeto resolve essa limitação implementando uma 
solução completa de dados.

## 🛠️ Tecnologias
- SQL Server
- SSMS (SGBD usado para gerenciamento dos dados)
- SSIS (em desenvolvimento)
- Power BI (em desenvolvimento)

## 📐 Arquitetura
OLTP → Stage → DataWarehouse → Power BI

## ✅ Etapas Concluídas

### 01 - OLTP ✅
- Modelagem Conceitual MER e DER (notação Peter Chen)
- Modelagem Lógica com normalização 1FN, 2FN e 3FN
- Modelo Físico com 4 schemas e 14 tabelas
- Constraints: PK, FK, UNIQUE, CHECK, DEFAULT
- Queries níveis básico ao avançado
- 4 Views analíticas
- 2 Triggers
- 1 Stored Procedure
- 5 Views de extração para o Stage

## 📐 Modelagem OLTP

### Modelo Conceitual — DER
![DER](docs/oltp/DER-MER.png)

### Modelo Lógico
![Modelo Lógico](docs/oltp/Modelo-Logico.png)

### 02 - Stage ✅
- Banco Stage_TechSales criado
- 5 tabelas de staging no schema dbo (Será criado Schema stage futuramente)
- Procedure de carga com log de auditoria
- Admin_Log para rastreabilidade das cargas

### 03 - DataWarehouse ✅
- Banco Datawarehouse_TechSales criado
- Modelagem Star Schema
- 4 dimensões: dim_Cliente, dim_Produto,
dim_Vendedor, dim_Tempo
- 1 tabela fato: fato_Vendas
- Admin_Log para rastreabilidade das cargas
- 5 Procedures de carga ETL Stage → DW:
- load_dim_Tempo
- load_dim_Cliente
- load_dim_Produto
- load_dim_Vendedor
- load_fato_Vendas

## ⚙️ Automação — SQL Server Agent JOB

### Processo de Carga
Foi criado um JOB no SQL Server Agent para automatizar
a carga completa do pipeline diariamente às 00:00.

### Procedure Master de Carga
```sql
-- Executa todo o pipeline em sequência
EXEC load_all_Stage_AND_Datawarehouse

-- Fluxo executado:
-- 1. Carrega Stage a partir das views do OLTP
-- 2. Carrega dim_Cliente
-- 3. Carrega dim_Produto  
-- 4. Carrega dim_Vendedor
-- 5. Carrega dim_Tempo
-- 6. Carrega fato_Vendas
```

### ⚠️ Observação sobre carga incremental
Em produção as views de extração seriam
adaptadas para buscar apenas registros
do dia anterior via filtro de data.
Por se tratar de ambiente de testes e estudos
a carga foi implementada como full load
com WHERE NOT EXISTS no DW garantindo
idempotência sem duplicação.

## 📐 Modelagem DataWarehouse

### Modelo Conceitual — Star Schema
![Star Schema](docs/dw/DerDW.png)

### Modelo Lógico DW
![Modelo Lógico DW](docs/dw/ModeloLogicoDW.png)

### 04 - SSIS ✅
- Pacote ETL criado no Visual Studio
- Connection Managers configurados:
  TechSales_OLTP, Stage_TechSales, 
  Datawarehouse_TechSales
- Fluxo do pacote:
  → Container Carga Stage: Execute SQL → Carrega_Stage_TechSales
  → Container Carga Data Warehouse: Execute SQL → load_all_Stage_AND_Datawarehouse
- Log de sucesso e falha em cada etapa
- Agendamento via SQL Server Agent Job
  executado diariamente às 01:00 AM

### Fluxo Completo
![Fluxo Completo](docs/ssis/fluxo-completo.png)

### Job rodando o pacote
![Job rodando o pacote](docs/ssis/Job-Pacote.png)

## ⏳ Em Desenvolvimento
- Dashboard Power BI

## 📁 Estrutura do Repositório
01-oltp/          → Banco operacional
02-stage/         → Banco de staging
03-datawarehouse/ → Banco analítico
04-ssis/          → Pacotes ETL
05-bi/            → Dashboard Power BI
docs/             → Diagramas e documentação