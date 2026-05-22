CREATE DATABASE Datawarehouse_TechSales
GO

USE Datawarehouse_TechSales
GO

-- ============================================
-- Tabela de Log para monitoramento de processos de ETL e outras operações administrativas
-- ============================================
CREATE TABLE Admin_Log (
    id_log      UNIQUEIDENTIFIER  DEFAULT NEWID(),
    data_log    DATETIME          DEFAULT GETDATE(),
    processo    VARCHAR(100),
    status      CHAR(1),
    mensagem    VARCHAR(255),
    CONSTRAINT PK_Admin_Log PRIMARY KEY (id_log)
)

-- ============================================
-- Esquema de Data Warehouse para TechSales
-- ============================================
CREATE TABLE dim_Cliente(	
sk_cliente		INT				IDENTITY,
nk_cliente		INT				NOT NULL,
nome_cliente	VARCHAR(150)	NOT NULL,
tipo_cliente	CHAR(2)			NOT NULL,
cpf_cnpj		VARCHAR(14)		NOT NULL,
email			VARCHAR(100)	NOT NULL,
telefone		VARCHAR(20)		NOT NULL,
segmento		VARCHAR(50)		NOT NULL,
cidade			VARCHAR(80),
estado			CHAR(2),
[status]		BIT				NOT NULL,
data_cadastro	DATE			NOT NULL,

CONSTRAINT PK_dim_Cliente PRIMARY KEY (sk_cliente),
CONSTRAINT UQ_dim_Cliente  UNIQUE (nk_cliente)
)
GO

CREATE TABLE dim_Vendedor(	
sk_vendedor		INT				IDENTITY,
nk_vendedor		INT				NOT NULL,
nome_vendedor	VARCHAR(150)	NOT NULL,
nome_gerente	VARCHAR(150),
cpf				CHAR(11)		NOT NULL,
email			VARCHAR(100)	NOT NULL,
telefone		VARCHAR(20)		NOT NULL,
cargo			VARCHAR(80)		NOT NULL,
nome_regiao		VARCHAR(30)		NOT NULL,
data_admissao	DATE			NOT NULL,
[status]		BIT				NOT NULL,

CONSTRAINT PK_dim_Vendedor PRIMARY KEY (sk_vendedor),
CONSTRAINT UQ_dim_Vendedor  UNIQUE (nk_vendedor)
)
GO

CREATE TABLE dim_Produto(	
sk_produto			INT				IDENTITY,
nk_produto			INT				NOT NULL,
nome_produto		VARCHAR(150)	NOT NULL,
descricao			VARCHAR(255),
preco_custo			DECIMAL(15,2)	NOT NULL,
preco_venda			DECIMAL(15, 2)	NOT NULL,
unidade_medida		VARCHAR(5)		NOT NULL,
estoque_atual		INT				NOT NULL,
estoque_minimo		INT				NOT NULL,
nome_subcategoria	VARCHAR(100)	NOT NULL,
nome_categoria		VARCHAR(100)	NOT NULL,
nome_fornecedor		VARCHAR(180)	NOT NULL,
[status]			BIT				NOT NULL,

CONSTRAINT PK_dim_Produto PRIMARY KEY (sk_produto),
CONSTRAINT UQ_dim_Produto  UNIQUE (nk_produto)
)
GO

CREATE TABLE dim_Tempo(	
sk_tempo			INT				IDENTITY,
data_completa		DATE			NOT NULL,
dia					INT				NOT NULL,
mes					INT				NOT NULL,
nome_mes			VARCHAR(30)		NOT NULL,
trimestre			INT				NOT NULL,
semestre			INT				NOT NULL,
ano					INT				NOT NULL,
dia_semana			INT				NOT NULL,
nome_dia_semana		VARCHAR(50)		NOT NULL,
fim_de_semana		BIT				NOT NULL,

CONSTRAINT UQ_dim_Tempo UNIQUE (data_completa),
CONSTRAINT PK_dim_Tempo PRIMARY KEY (sk_tempo)
)
GO

CREATE TABLE fato_Vendas(	
sk_venda				INT				IDENTITY,
sk_cliente				INT				NOT NULL,
sk_produto				INT				NOT NULL,
sk_vendedor				INT				NOT NULL,
sk_tempo				INT				NOT NULL,
nk_pedido				INT				NOT NULL,
nk_item					INT				NOT NULL,
quantidade				INT				NOT NULL,
preco_unitario			DECIMAL(15,2)	NOT NULL,
desconto_item			DECIMAL(5,2)	NOT NULL DEFAULT 0,
desconto_pedido			DECIMAL(15,2)	NOT NULL DEFAULT 0,
valor_bruto				DECIMAL(15,2)	NOT NULL,
valor_liquido			DECIMAL(15,2)	NOT NULL,
lucro_bruto				DECIMAL(15,2)	NOT NULL,
valor_frete				DECIMAL(10,2)	NOT NULL DEFAULT 0,
status_pedido			VARCHAR(50)		NOT NULL,
tipo_frete				CHAR(3)			NOT NULL,
forma_pagamento			VARCHAR(20)		NOT NULL,
condicao_pagamento		VARCHAR(50)		NOT NULL,

CONSTRAINT PK_fato_Vendas PRIMARY KEY (sk_venda),
CONSTRAINT UQ_fato_Vendas  UNIQUE (nk_item),

CONSTRAINT FK_Vendas_Cliente FOREIGN KEY (sk_cliente)
REFERENCES dim_Cliente (sk_cliente),
CONSTRAINT FK_Vendas_Produto FOREIGN KEY (sk_produto)
REFERENCES dim_Produto (sk_produto),
CONSTRAINT FK_Vendas_Vendedor FOREIGN KEY (sk_vendedor)
REFERENCES dim_Vendedor (sk_vendedor),
CONSTRAINT FK_Vendas_Tempo FOREIGN KEY (sk_tempo)
REFERENCES dim_Tempo (sk_tempo)
)
GO


