
USE TechSales;
GO

-- ============================================
-- SCHEMA: cadastro
-- Cliente, Endereco_Cliente, 
-- Fornecedor, Endereco_Fornecedor
-- ============================================

CREATE TABLE cadastro.Cliente (
    id_cliente        INT          NOT NULL IDENTITY,
    tipo_cliente      CHAR(2)      NOT NULL,
    nome_razao_social VARCHAR(150) NOT NULL,
    cpf_cnpj          VARCHAR(14)  NOT NULL,
    email             VARCHAR(100) NOT NULL,
    telefone          VARCHAR(20)  NOT NULL,
    segmento          VARCHAR(50)  NOT NULL,
    data_cadastro     DATE         NOT NULL DEFAULT GETDATE(),
    ativo             BIT          NOT NULL DEFAULT 1,

    CONSTRAINT PK_Cliente         PRIMARY KEY (id_cliente),
    CONSTRAINT UQ_Cliente_CpfCnpj UNIQUE      (cpf_cnpj),
    CONSTRAINT CK_Cliente_Tipo    CHECK        (tipo_cliente IN ('PF', 'PJ')),
    CONSTRAINT CK_Cliente_CpfCnpj CHECK (
        (tipo_cliente = 'PF' AND LEN(cpf_cnpj) = 11) OR
        (tipo_cliente = 'PJ' AND LEN(cpf_cnpj) = 14)
    )
)
GO

CREATE TABLE cadastro.Endereco_Cliente (
    id_endereco   INT          NOT NULL IDENTITY,
    id_cliente    INT          NOT NULL,
    tipo_endereco VARCHAR(20)  NOT NULL,
    logradouro    VARCHAR(150) NOT NULL,
    numero        VARCHAR(10)  NOT NULL,
    complemento   VARCHAR(50)  NULL,
    bairro        VARCHAR(80)  NOT NULL,
    cidade        VARCHAR(80)  NOT NULL,
    estado        CHAR(2)      NOT NULL,
    cep           CHAR(8)      NOT NULL,

    CONSTRAINT PK_Endereco_Cliente  PRIMARY KEY (id_endereco),
    CONSTRAINT FK_Endereco_Cliente  FOREIGN KEY (id_cliente)
        REFERENCES cadastro.Cliente (id_cliente),
    CONSTRAINT CK_Tipo_Endereco     CHECK (
        tipo_endereco IN ('Principal', 'Cobranca', 'Entrega')
    )
)
GO

CREATE TABLE cadastro.Fornecedor (
    id_fornecedor INT          NOT NULL IDENTITY,
    razao_social  VARCHAR(180) NOT NULL,
    cnpj          CHAR(14)     NOT NULL,
    email         VARCHAR(100) NOT NULL,
    telefone      VARCHAR(20)  NOT NULL,

    CONSTRAINT PK_Fornecedor      PRIMARY KEY (id_fornecedor),
    CONSTRAINT UQ_Fornecedor_Cnpj UNIQUE      (cnpj)
)
GO

CREATE TABLE cadastro.Endereco_Fornecedor (
    id_endereco   INT          NOT NULL IDENTITY,
    id_fornecedor INT          NOT NULL,
    logradouro    VARCHAR(150) NOT NULL,
    numero        VARCHAR(10)  NOT NULL,
    complemento   VARCHAR(50)  NULL,
    bairro        VARCHAR(80)  NOT NULL,
    cidade        VARCHAR(80)  NOT NULL,
    estado        CHAR(2)      NOT NULL,
    cep           CHAR(8)      NOT NULL,

    CONSTRAINT PK_Endereco_Fornecedor PRIMARY KEY (id_endereco),
    CONSTRAINT FK_Endereco_Fornecedor FOREIGN KEY (id_fornecedor)
        REFERENCES cadastro.Fornecedor (id_fornecedor)
)
GO

-- ============================================
-- SCHEMA: estoque
-- Categoria, Sub_Categoria, 
-- Produto, Movimentacao_Estoque
-- ============================================

CREATE TABLE estoque.Categoria (
    id_categoria   INT          NOT NULL IDENTITY,
    nome_categoria VARCHAR(100) NOT NULL,
    descricao      VARCHAR(255) NULL,

    CONSTRAINT PK_Categoria PRIMARY KEY (id_categoria)
)
GO

CREATE TABLE estoque.Sub_Categoria (
    id_subcategoria   INT          NOT NULL IDENTITY,
    id_categoria      INT          NOT NULL,
    nome_subcategoria VARCHAR(100) NOT NULL,
    descricao         VARCHAR(255) NULL,

    CONSTRAINT PK_Sub_Categoria          PRIMARY KEY (id_subcategoria),
    CONSTRAINT FK_Sub_Categoria_Categoria FOREIGN KEY (id_categoria)
        REFERENCES estoque.Categoria (id_categoria)
)
GO

CREATE TABLE estoque.Produto (
    id_produto      INT           NOT NULL IDENTITY,
    id_fornecedor   INT           NOT NULL,
    id_subcategoria INT           NOT NULL,
    nome_produto    VARCHAR(150)  NOT NULL,
    descricao       VARCHAR(255)  NULL,
    preco_custo     DECIMAL(15,2) NOT NULL,
    preco_venda     DECIMAL(15,2) NOT NULL,
    unidade_medida  VARCHAR(5)    NOT NULL,
    estoque_atual   INT           NOT NULL DEFAULT 0,
    estoque_minimo  INT           NOT NULL,
    ativo           BIT           NOT NULL DEFAULT 1,

    CONSTRAINT PK_Produto              PRIMARY KEY (id_produto),
    CONSTRAINT FK_Produto_Fornecedor   FOREIGN KEY (id_fornecedor)
        REFERENCES cadastro.Fornecedor (id_fornecedor),
    CONSTRAINT FK_Produto_Sub_Categoria FOREIGN KEY (id_subcategoria)
        REFERENCES estoque.Sub_Categoria (id_subcategoria),
    CONSTRAINT CK_Produto_Unidade_Medida CHECK (
        unidade_medida IN ('UN', 'CX', 'KIT', 'LIC', 'PAR')
    )
)
GO

-- ============================================
-- SCHEMA: vendas
-- Regiao, Vendedor, 
-- Vendedor_Regiao, Meta
-- ============================================

CREATE TABLE vendas.Regiao (
    id_regiao   INT          NOT NULL IDENTITY,
    nome_regiao VARCHAR(30)  NOT NULL,
    descricao   VARCHAR(255) NULL,

    CONSTRAINT PK_Regiao PRIMARY KEY (id_regiao)
)
GO

CREATE TABLE vendas.Vendedor (
    id_vendedor   INT          NOT NULL IDENTITY,
    id_gerente    INT          NULL,
    id_regiao     INT          NOT NULL,
    nome_vendedor VARCHAR(150) NOT NULL,
    cpf           CHAR(11)     NOT NULL,
    email         VARCHAR(100) NOT NULL,
    telefone      VARCHAR(20)  NOT NULL,
    cargo         VARCHAR(80)  NOT NULL,
    data_admissao DATE         NOT NULL,
    ativo         BIT          NOT NULL DEFAULT 1,

    CONSTRAINT PK_Vendedor         PRIMARY KEY (id_vendedor),
    CONSTRAINT FK_Vendedor_Gerente FOREIGN KEY (id_gerente)
        REFERENCES vendas.Vendedor (id_vendedor),
    CONSTRAINT FK_Vendedor_Regiao  FOREIGN KEY (id_regiao)
        REFERENCES vendas.Regiao (id_regiao),
    CONSTRAINT UQ_Vendedor_Cpf     UNIQUE (cpf)
)
GO

CREATE TABLE vendas.Vendedor_Regiao (
    id_vendedor_regiao INT  NOT NULL IDENTITY,
    id_vendedor        INT  NOT NULL,
    id_regiao          INT  NOT NULL,
    data_inicio        DATE NOT NULL,
    data_fim           DATE NULL,

    CONSTRAINT PK_Vendedor_Regiao          PRIMARY KEY (id_vendedor_regiao),
    CONSTRAINT FK_Vendedor_Regiao_Vendedor FOREIGN KEY (id_vendedor)
        REFERENCES vendas.Vendedor (id_vendedor),
    CONSTRAINT FK_Vendedor_Regiao_Regiao   FOREIGN KEY (id_regiao)
        REFERENCES vendas.Regiao (id_regiao)
)
GO

CREATE TABLE vendas.Meta (
    id_meta     INT           NOT NULL IDENTITY,
    id_vendedor INT           NOT NULL,
    periodo     DATE          NOT NULL,
    valor_meta  DECIMAL(15,2) NOT NULL,

    CONSTRAINT PK_Meta                  PRIMARY KEY (id_meta),
    CONSTRAINT FK_Meta_Vendedor         FOREIGN KEY (id_vendedor)
        REFERENCES vendas.Vendedor (id_vendedor),
    CONSTRAINT UQ_Meta_Vendedor_Periodo UNIQUE (id_vendedor, periodo)
    CONSTRAINT CK_Meta_Sem_Gerente CHECK (
    id_vendedor NOT IN (
        SELECT id_vendedor FROM vendas.Vendedor
        WHERE cargo = 'Gerente'
    )
);
)
GO

-- ============================================
-- SCHEMA: comercial
-- Pedido, Item_Pedido
-- ============================================

CREATE TABLE comercial.Pedido (
    id_pedido            INT           NOT NULL IDENTITY,
    id_cliente           INT           NOT NULL,
    id_vendedor          INT           NOT NULL,
    id_endereco_entrega  INT           NOT NULL,
    data_pedido          DATE          NOT NULL DEFAULT GETDATE(),
    [status]             VARCHAR(50)   NOT NULL,
    motivo_cancelamento  VARCHAR(255)  NULL,
    tipo_frete           CHAR(3)       NOT NULL,
    valor_frete          DECIMAL(10,2) NOT NULL DEFAULT 0,
    desconto_pedido      DECIMAL(15,2) NULL,
    forma_pagamento      VARCHAR(20)   NOT NULL,
    condicao_pagamento   VARCHAR(50)   NOT NULL DEFAULT 'A vista',
    observacoes          VARCHAR(255)  NULL,
    data_atualizacao     DATE          NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_Pedido                  PRIMARY KEY (id_pedido),
    CONSTRAINT FK_Pedido_Cliente          FOREIGN KEY (id_cliente)
        REFERENCES cadastro.Cliente (id_cliente),
    CONSTRAINT FK_Pedido_Vendedor         FOREIGN KEY (id_vendedor)
        REFERENCES vendas.Vendedor (id_vendedor),
    CONSTRAINT FK_Pedido_Endereco_Cliente FOREIGN KEY (id_endereco_entrega)
        REFERENCES cadastro.Endereco_Cliente (id_endereco),
    CONSTRAINT CK_Pedido_Tipo_Frete       CHECK (tipo_frete IN ('CIF', 'FOB')),
    CONSTRAINT CK_Pedido_Forma_Pagamento  CHECK (
        forma_pagamento IN ('Boleto', 'Cartao', 'PIX', 'Transferencia')
    ),
    CONSTRAINT CK_Pedido_Status           CHECK (
        [status] IN ('Aguardando', 'Aprovado', 'Em Separacao', 'Enviado', 'Entregue', 'Cancelado')
    ),
    CONSTRAINT CK_Pedido_Condicao_Pagamento CHECK (
        condicao_pagamento IN ('A vista', '30 dias', '60 dias', '90 dias')
    )
    CONSTRAINT CK_Pedido_Motivo_Cancelamento CHECK (
    [status] != 'Cancelado' OR
    ([status] = 'Cancelado' AND motivo_cancelamento IS NOT NULL)
);
)
GO

CREATE TABLE comercial.Item_Pedido (
    id_item_pedido     INT           NOT NULL IDENTITY,
    id_pedido          INT           NOT NULL,
    id_produto         INT           NOT NULL,
    quantidade         INT           NOT NULL,
    preco_unitario     DECIMAL(15,2) NOT NULL,
    desconto_item      DECIMAL(5,2)  NULL,
    aprovacao_desconto BIT           NOT NULL DEFAULT 0,

    CONSTRAINT PK_Item_Pedido            PRIMARY KEY (id_item_pedido),
    CONSTRAINT FK_Item_Pedido_Pedido     FOREIGN KEY (id_pedido)
        REFERENCES comercial.Pedido (id_pedido),
    CONSTRAINT FK_Item_Pedido_Produto    FOREIGN KEY (id_produto)
        REFERENCES estoque.Produto (id_produto),
    CONSTRAINT CK_Item_Pedido_Quantidade CHECK (quantidade > 0),
    CONSTRAINT CK_Item_Pedido_Desconto   CHECK (
        desconto_item IS NULL OR
        desconto_item BETWEEN 0 AND 100
    ),
    CONSTRAINT CK_Item_Aprovacao_Desconto CHECK (
        desconto_item IS NULL OR
        desconto_item <= 30 OR
        (desconto_item > 30 AND aprovacao_desconto = 1)
    )
)
GO

CREATE TABLE estoque.Movimentacao_Estoque (
    id_movimentacao   INT          NOT NULL IDENTITY,
    id_produto        INT          NOT NULL,
    id_pedido         INT          NULL,
    id_fornecedor     INT          NULL,
    id_vendedor       INT          NOT NULL,
    tipo_movimentacao VARCHAR(25)  NOT NULL,
    quantidade        INT          NOT NULL,
    data_movimentacao DATETIME     NOT NULL DEFAULT GETDATE(),
    observacao        VARCHAR(255) NULL,

    CONSTRAINT PK_Movimentacao                  PRIMARY KEY (id_movimentacao),
    CONSTRAINT FK_Movimentacao_Produto          FOREIGN KEY (id_produto)
        REFERENCES estoque.Produto (id_produto),
    CONSTRAINT FK_Movimentacao_Pedido           FOREIGN KEY (id_pedido)
        REFERENCES comercial.Pedido (id_pedido),
    CONSTRAINT FK_Movimentacao_Fornecedor       FOREIGN KEY (id_fornecedor)
        REFERENCES cadastro.Fornecedor (id_fornecedor),
    CONSTRAINT FK_Movimentacao_Vendedor         FOREIGN KEY (id_vendedor)
        REFERENCES vendas.Vendedor (id_vendedor),
    CONSTRAINT CK_Movimentacao_Tipo             CHECK (
        tipo_movimentacao IN ('Entrada', 'Saida', 'Ajuste')
    ),
    CONSTRAINT CK_Movimentacao_Quantidade       CHECK (quantidade >= 1)
)
GO