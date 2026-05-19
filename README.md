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

### 02 - Stage ✅
- Banco Stage_TechSales criado
- 5 tabelas de staging no schema dbo (Será criado Schema stage futuramente)
- Procedure de carga com log de auditoria
- Admin_Log para rastreabilidade das cargas

### 03 - DataWarehouse ⏳
- Banco Datawarehouse_TechSales criado
- Modelagem Star Schema
- 4 dimensões: dim_Cliente, dim_Produto, 
  dim_Vendedor, dim_Tempo
- 1 tabela fato: fato_Vendas
- Carga ETL Stage → DW (em desenvolvimento)

## ⏳ Em Desenvolvimento
- DataWarehouse (Star Schema)
- ETL com SSIS
- Dashboard Power BI

## 📁 Estrutura do Repositório
01-oltp/          → Banco operacional
02-stage/         → Banco de staging
03-datawarehouse/ → Banco analítico
04-ssis/          → Pacotes ETL
05-bi/            → Dashboard Power BI
docs/             → Diagramas e documentação