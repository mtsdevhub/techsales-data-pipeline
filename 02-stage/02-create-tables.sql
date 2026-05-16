-- ============================================
-- Tabela stg_Clientes para receber os dados de clientes do banco de origem (TechSales_OLTP)
-- ============================================
CREATE TABLE stg_Clientes (
   id_stg			INT IDENTITY,
   data_carga		DATETIME		DEFAULT GETDATE(),
   origem			VARCHAR(50)		DEFAULT 'TechSales_OLTP',
    CodOrigemCliente			INT,
    TipoCliente					CHAR(2),
    NomeCliente					VARCHAR(150),
    CpfCnpjCliente				VARCHAR(14),
	EmailCliente				VARCHAR(100),
	TelefoneCliente				VARCHAR(20),
	SegmentoCliente				VARCHAR(50),
	DataCadastroCliente			DATE,
	StatusCliente				BIT,
	TipoEnderecoCliente			VARCHAR(20),
	LogradouroEnderecoCliente	VARCHAR(150),
	NumeroEnderecoCliente		VARCHAR(10),
	ComplementoEnderecoCliente	VARCHAR(50),
	BairroEnderecoCliente		VARCHAR(80),
	CidadeEnderecoCliente		VARCHAR(80),
	EstadoEnderecoCliente		CHAR(2),
	CepEnderecoCliente			CHAR(8),

    CONSTRAINT PK_stg_Clientes PRIMARY KEY (id_stg)
)
GO

-- ============================================
-- Tabela stg_Produtos para receber os dados de produtos do banco de origem (TechSales_OLTP)
-- ============================================
CREATE TABLE stg_Produtos (
    id_stg			INT IDENTITY,
    data_carga		DATETIME		DEFAULT GETDATE(),
    origem			VARCHAR(50)		DEFAULT 'TechSales_OLTP',
    CodOrigemProduto			INT,
    CodFornecedor				INT,
    CodSubCategoria				INT,
    NomeProduto					VARCHAR(150),
	DescricaoProduto			VARCHAR(255),
	PrecoCustoProduto			DECIMAL(15, 2),
	PrecoVendaProduto			DECIMAL(15, 2),
	UnidadeMedidaProduto		VARCHAR(5),
	EstoqueAtualProduto			INT,
	EstoqueMinimoProduto		INT,
	StatusProduto				BIT,
	NomeFornecedor				VARCHAR(180),
	CnpjFornecedor				CHAR(14),
	EmailFornecedor				VARCHAR(100),
	TelefoneFornecedor			VARCHAR(20),
	NomeSubCategoriaProduto		VARCHAR(100),
	DescricaoSubCategoria		VARCHAR(255),
	NomeCategoriaProduto		VARCHAR(100),
	DescricaoCategoria			VARCHAR(255),

    CONSTRAINT PK_stg_Produtos PRIMARY KEY (id_stg)
)
GO

-- ============================================
-- Tabela stg_Vendedores para receber os dados de vendedores do banco de origem (TechSales_OLTP)
-- ============================================
CREATE TABLE stg_Vendedores (
    id_stg			INT IDENTITY,
    data_carga		DATETIME		DEFAULT GETDATE(),
    origem			VARCHAR(50)		DEFAULT 'TechSales_OLTP',
    CodOrigemVendedor			INT,
    CodRegiao					INT,
    NomeVendedor				VARCHAR(150),
    NomeGerente					VARCHAR(150),
	CpfVendedor					CHAR(11),
	EmailVendedor				VARCHAR(100),
	TelefoneVendedor			VARCHAR(20),
	CargoVendedor				VARCHAR(80),
	DataAdmissaoVendedor		DATE,
	StatusVendedor				BIT,
	NomeRegiaoVendedor			VARCHAR(30),
	DescricaoRegiao				VARCHAR(255),
    CONSTRAINT PK_stg_Vendedores PRIMARY KEY (id_stg)
)
GO

-- ============================================
-- Tabela stg_Vendas para receber os dados de vendas do banco de origem (TechSales_OLTP)
-- ============================================
CREATE TABLE stg_Vendas (
    id_stg			INT IDENTITY,
    data_carga		DATETIME		DEFAULT GETDATE(),
    origem			VARCHAR(50)		DEFAULT 'TechSales_OLTP',
    CodOrigemPedido				INT,
    CodCliente					INT,
    CodVendedor					INT,
    CodEnderecoEntrega			INT,
	DataPedido					DATE,
	StatusPedido				VARCHAR(50),
	MotivoCancelamento			VARCHAR(255),
	TipoFrete					CHAR(3),
	ValorFrete					DECIMAL(10,2),
	DescontoPedido				DECIMAL(15,2),
	FormaPagamento				VARCHAR(20),
	CondicaoPagamento			VARCHAR(50),
	ObservacaoPedido			VARCHAR(255),
	DataAtualizacaoPedido		DATE,
	QuantidadeItens				INT,
	ValorBruto					DECIMAL(15,2),
	ValorLiquido				DECIMAL(15,2),
    CONSTRAINT PK_stg_Vendas PRIMARY KEY (id_stg)
)
GO

-- ============================================
-- Tabela stg_Itens_Pedido para receber os dados de itens de pedido do banco de origem (TechSales_OLTP)
-- ============================================
CREATE TABLE stg_Itens_Pedido (
    id_stg			INT IDENTITY,
    data_carga		DATETIME		DEFAULT GETDATE(),
    origem			VARCHAR(50)		DEFAULT 'TechSales_OLTP',
    CodOrigemItem			INT,
    CodPedido					INT,
    CodProduto					INT,
    QuantidadeItem				INT,
	PrecoUnitarioItem			DECIMAL(15,2),
	DescontoItem				DECIMAL(5,2),
	AprovacaoDesconto			BIT,
	DataPedido					DATE,
	StatusPedido				VARCHAR(50),
	DescontoPedido				DECIMAL(15,2),
	ValorBruto					DECIMAL(15,2),
	ValorLiquido				DECIMAL(15,2),
	LucroBruto					DECIMAL(15,2),
    CONSTRAINT PK_stg_Itens_Pedido PRIMARY KEY (id_stg)
)
GO