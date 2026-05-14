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

### 01 - OLTP
- Modelagem Conceitual MER e DER (notação Peter Chen)
- Modelagem Lógica com normalização 1FN, 2FN e 3FN
- Modelo Físico com 4 schemas e 14 tabelas
- Constraints: PK, FK, UNIQUE, CHECK, DEFAULT
- Queries níveis básico ao avançado
- 4 Views analíticas
- 2 Triggers
- 1 Stored Procedure
- 4 Views de extração para o Stage

## ⏳ Em Desenvolvimento
- Banco Stage
- DataWarehouse (Star Schema)
- ETL com SSIS e SQL
- Dashboard Power BI

## 📁 Estrutura do Repositório
01-oltp/          → Banco operacional
02-stage/         → Banco de staging
03-datawarehouse/ → Banco analítico
04-ssis/          → Pacotes ETL
05-bi/            → Dashboard Power BI
docs/             → Diagramas e documentação