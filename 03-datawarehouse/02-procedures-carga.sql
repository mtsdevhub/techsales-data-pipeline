Use Datawarehouse_TechSales;
GO



-- ============================================
-- Procedure para carregar todos os dados do Stage e Data Warehouse (Automatização do pipeline ETL) será rodado diariamente pelo SQL Agent
-- ============================================
CREATE OR ALTER PROCEDURE load_all_Stage_AND_Datawarehouse
AS
BEGIN
    EXEC Stage_TechSales..[Carrega_Stage_TechSales];
 
	EXEC Datawarehouse_TechSales..[load_dim_cliente];
	EXEC Datawarehouse_TechSales..[load_dim_Produto];
	EXEC Datawarehouse_TechSales..[load_dim_Tempo];
	EXEC Datawarehouse_TechSales..[load_dim_Vendedor];
	EXEC Datawarehouse_TechSales..[load_fato_Vendas];
END;

-- ============================================
-- Procedures de carga para as dimensões e fatos do Data Warehouse TechSales
-- ============================================
CREATE OR ALTER PROCEDURE load_dim_cliente
AS
BEGIN TRY
	INSERT INTO Datawarehouse_Techsales..dim_Cliente(
	nk_cliente,
	nome_cliente,
	tipo_cliente,
	cpf_cnpj,
	email,
	telefone,
	segmento,
	cidade,
	estado,
	[status],
	data_cadastro
	)
	SELECT DISTINCT
	CodOrigemCliente,
	NomeCliente,
	TipoCliente,
	CpfCnpjCliente,
	EmailCliente,
	TelefoneCliente,
	SegmentoCliente,
	CidadeEnderecoCliente,
	EstadoEnderecoCliente,
	StatusCliente,
	DataCadastroCliente
	FROM Stage_TechSales..stg_Clientes stg
	WHERE NOT EXISTS(
		SELECT 1
		FROM Datawarehouse_TechSales..dim_Cliente dw
		WHERE dw.nk_cliente = stg.CodOrigemCliente
	)
	
	
	DECLARE @RecordsInserted INT;
    SET     @RecordsInserted = @@ROWCOUNT;

    -- ============================================
    -- Log de sucesso com totais por tabela
    -- ============================================
	IF @RecordsInserted > 0
	BEGIN
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'load_dim_cliente',
        'S',
        CONCAT(
            'Carga realizada com sucesso! ' ,@RecordsInserted,  ' | '
        )
    )
	END
	ELSE
	BEGIN
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'load_dim_cliente',
        'S',
        'Executado com sucesso, por m sem novos registros'
    )
END
END TRY
BEGIN CATCH
    -- ============================================
    -- Log de erro com detalhes
    -- ============================================
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'load_dim_cliente',
        'F',
        CONCAT(
            'Erro: ',   ERROR_MESSAGE(),
            ' Linha: ', ERROR_LINE()
        )
    )
END CATCH
GO

EXEC load_dim_cliente
SELECT * FROM dim_Cliente
SELECT * FROM Admin_Log ORDER BY data_log DESC

-- ============================================

CREATE OR ALTER PROCEDURE load_dim_Tempo 
AS
BEGIN TRY
	INSERT INTO Datawarehouse_TechSales..[dim_Tempo](
	data_completa,
	dia,
	mes,
	nome_mes,
	trimestre,
	semestre,
	ano,
	dia_semana,
	nome_dia_semana,
	fim_de_semana
	)
    SELECT DISTINCT
    DataPedido AS DataCompleta,
	DAY(DataPedido)   AS dia,
	MONTH(DataPedido) AS mes,
	CASE
        WHEN MONTH([DataPedido]) = 01 THEN 'Janeiro'
        WHEN MONTH([DataPedido]) = 02 THEN 'Fevereiro'
        WHEN MONTH([DataPedido]) = 03 THEN 'Mar o'
        WHEN MONTH([DataPedido]) = 04 THEN 'Abril'
		WHEN MONTH([DataPedido]) = 05 THEN 'Maio'
        WHEN MONTH([DataPedido]) = 06 THEN 'Junho'
        WHEN MONTH([DataPedido]) = 07 THEN 'Julho'
		WHEN MONTH([DataPedido]) = 08 THEN 'Agosto'
		WHEN MONTH([DataPedido]) = 09 THEN 'Setembro'
		WHEN MONTH([DataPedido]) = 10 THEN 'Outubro'
		WHEN MONTH([DataPedido]) = 11 THEN 'Novembro'
		WHEN MONTH([DataPedido]) = 12 THEN 'Dezembro'
        ELSE 'Invalido' 
	END AS NomeMes,
	CASE
		WHEN MONTH(DataPedido) BETWEEN 1 AND 3 THEN 1
        WHEN MONTH(DataPedido) BETWEEN 4 AND 6 THEN 2
        WHEN MONTH(DataPedido) BETWEEN 7 AND 9 THEN 3
        ELSE 4
	END AS Trimestre,
	CASE
        WHEN MONTH(DataPedido) BETWEEN 1 AND 6 THEN 1
        ELSE 2
	END AS Semestre,
	YEAR([DataPedido]) AS Ano,
	DATEPART(WEEKDAY, DataPedido) AS DiaSemana,
	CASE DATEPART(WEEKDAY, DataPedido)
		WHEN 1 THEN 'Domingo'
		WHEN 2 THEN 'Segunda-feira'
		WHEN 3 THEN 'Ter a-feira'
		WHEN 4 THEN 'Quarta-feira'
		WHEN 5 THEN 'Quinta-feira'
		WHEN 6 THEN 'Sexta-feira'
		WHEN 7 THEN 'S bado'
		ELSE 'Invalido'
	END AS NomeDiaSemana,
	CASE
		WHEN DATEPART(WEEKDAY, DataPedido) IN (1, 7) THEN 1
		ELSE 0
	END AS FimDeSemana
	FROM [Stage_TechSales]..[stg_Itens_Pedido] i
	WHERE NOT EXISTS(
		SELECT 1
		FROM Datawarehouse_TechSales..dim_Tempo t
		WHERE t.data_completa = i.DataPedido
	)
		
	
	DECLARE @RecordsInserted INT;
    SET     @RecordsInserted = @@ROWCOUNT;

    -- ============================================
    -- Log de sucesso com totais por tabela
    -- ============================================
	IF @RecordsInserted > 0
	BEGIN
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'load_dim_Tempo ',
        'S',
        CONCAT(
            'Carga realizada com sucesso! ' ,@RecordsInserted, ' registros inseridos' 
        )
    )
	END
	ELSE
	BEGIN
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'load_dim_Tempo ',
        'S',
        'Executado com sucesso, por m sem novos registros'
    )
END
END TRY
BEGIN CATCH
    -- ============================================
    -- Log de erro com detalhes
    -- ============================================
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'load_dim_Tempo ',
        'F',
        CONCAT(
            'Erro: ',   ERROR_MESSAGE(),
            'Linha: ', ERROR_LINE()
        )
    )
END CATCH
GO

EXEC load_dim_Tempo
SELECT * FROM dim_Tempo
SELECT * FROM Admin_Log ORDER BY data_log DESC

-- ============================================

CREATE OR ALTER PROCEDURE load_dim_Produto
AS
BEGIN TRY
	INSERT INTO Datawarehouse_Techsales..dim_Produto(
	nk_produto,
	nome_produto,
	descricao,
	preco_custo,
	preco_venda,
	unidade_medida,
	estoque_atual,
	estoque_minimo,
	nome_subcategoria,
	nome_categoria,
	nome_fornecedor,
	[status]
	)
	SELECT DISTINCT
	CodOrigemProduto,
	NomeProduto,
	DescricaoProduto,
	PrecoCustoProduto,
	PrecoVendaProduto,
	UnidadeMedidaProduto,
	EstoqueAtualProduto,
	EstoqueMinimoProduto,
	NomeSubCategoriaProduto,
	NomeCategoriaProduto,
	NomeFornecedor,
	StatusProduto
	FROM Stage_TechSales..stg_Produtos stg
	WHERE NOT EXISTS(
		SELECT 1
		FROM Datawarehouse_TechSales..dim_Produto dw
		WHERE dw.nk_produto = stg.CodOrigemProduto
	)
	
	
	DECLARE @RecordsInserted INT;
    SET     @RecordsInserted = @@ROWCOUNT;

    -- ============================================
    -- Log de sucesso com totais por tabela
    -- ============================================
	IF @RecordsInserted > 0
	BEGIN
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'load_dim_Produto',
        'S',
        CONCAT(
            'Carga realizada com sucesso! ' ,@RecordsInserted,  ' | '
        )
    )
	END
	ELSE
	BEGIN
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'load_dim_Produto',
        'S',
        'Executado com sucesso, por m sem novos registros'
    )
END
END TRY
BEGIN CATCH
    -- ============================================
    -- Log de erro com detalhes
    -- ============================================
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'load_dim_Produto',
        'F',
        CONCAT(
            'Erro: ',   ERROR_MESSAGE(),
            ' Linha: ', ERROR_LINE()
        )
    )
END CATCH
GO

EXEC load_dim_Produto
SELECT * FROM dim_Produto
SELECT * FROM Admin_Log ORDER BY data_log DESC

-- ============================================

CREATE OR ALTER PROCEDURE load_dim_Vendedor
AS
BEGIN TRY
	INSERT INTO Datawarehouse_Techsales..dim_Vendedor(
	nk_vendedor,
	nome_vendedor,
	nome_gerente,
	cpf,
	email,
	telefone,
	cargo,
	nome_regiao,
	data_admissao,
	[status]
	)
	SELECT DISTINCT
	CodOrigemVendedor,
	NomeVendedor,
	NomeGerente,
	CpfVendedor,
	EmailVendedor,
	TelefoneVendedor,
	CargoVendedor,
	NomeRegiaoVendedor,
	DataAdmissaoVendedor,
	StatusVendedor
	FROM Stage_TechSales..stg_Vendedores v
	WHERE NOT EXISTS(
		SELECT 1
		FROM Datawarehouse_TechSales..dim_Vendedor dw
		WHERE dw.nk_vendedor = v.CodOrigemVendedor
	)
	
	
	DECLARE @RecordsInserted INT;
    SET     @RecordsInserted = @@ROWCOUNT;

    -- ============================================
    -- Log de sucesso com totais por tabela
    -- ============================================
	IF @RecordsInserted > 0
	BEGIN
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'load_dim_Vendedor',
        'S',
        CONCAT(
            'Carga realizada com sucesso! ' ,@RecordsInserted,  ' | '
        )
    )
	END
	ELSE
	BEGIN
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'load_dim_Vendedor',
        'S',
        'Executado com sucesso, por m sem novos registros'
    )
END
END TRY
BEGIN CATCH
    -- ============================================
    -- Log de erro com detalhes
    -- ============================================
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'load_dim_Vendedor',
        'F',
        CONCAT(
            'Erro: ',   ERROR_MESSAGE(),
            ' Linha: ', ERROR_LINE()
        )
    )
END CATCH
GO

EXEC load_dim_Vendedor
SELECT * FROM dim_Vendedor
SELECT * FROM Admin_Log ORDER BY data_log DESC

-- ============================================

CREATE OR ALTER PROCEDURE load_fato_Vendas
AS
BEGIN TRY

    INSERT INTO Datawarehouse_TechSales..fato_Vendas (
        sk_cliente,
        sk_produto,
        sk_vendedor,
        sk_tempo,
        nk_pedido,
        nk_item,
        quantidade,
        preco_unitario,
        desconto_item,
        desconto_pedido,
        valor_bruto,
        valor_liquido,
        lucro_bruto,
        valor_frete,
        status_pedido,
        tipo_frete,
        forma_pagamento,
        condicao_pagamento
    )
    SELECT
        dc.sk_cliente,
        dp.sk_produto,
        dv.sk_vendedor,
        dt.sk_tempo,
        sv.CodOrigemPedido,
        si.CodOrigemItem,
        si.QuantidadeItem,
        si.PrecoUnitarioItem,
        si.DescontoItem,
        si.DescontoPedido,
        si.ValorBruto,
        si.ValorLiquido,
        si.LucroBruto,
        sv.ValorFrete,
        sv.StatusPedido,
        sv.TipoFrete,
        sv.FormaPagamento,
        sv.CondicaoPagamento
    FROM Stage_TechSales..stg_Itens_Pedido si
    INNER JOIN Stage_TechSales..stg_Vendas sv
        ON si.CodPedido = sv.CodOrigemPedido
    INNER JOIN Datawarehouse_TechSales..dim_Cliente dc
        ON sv.CodCliente = dc.nk_cliente
    INNER JOIN Datawarehouse_TechSales..dim_Produto dp
        ON si.CodProduto = dp.nk_produto
    INNER JOIN Datawarehouse_TechSales..dim_Vendedor dv
        ON sv.CodVendedor = dv.nk_vendedor
    INNER JOIN Datawarehouse_TechSales..dim_Tempo dt
        ON sv.DataPedido = dt.data_completa
    WHERE NOT EXISTS (
        SELECT 1
        FROM Datawarehouse_TechSales..fato_Vendas fv
        WHERE fv.nk_item = si.CodOrigemItem
    )

    DECLARE @RecordsInserted INT
    SET @RecordsInserted = @@ROWCOUNT

    IF @RecordsInserted > 0
    BEGIN
        INSERT INTO Datawarehouse_TechSales..Admin_Log
            (processo, status, mensagem)
        VALUES (
            'load_fato_Vendas',
            'S',
            CONCAT(
                'Carga realizada com sucesso! ',
                @RecordsInserted,
                ' registros inseridos'
            )
        )
    END
    ELSE
    BEGIN
        INSERT INTO Datawarehouse_TechSales..Admin_Log
            (processo, status, mensagem)
        VALUES (
            'load_fato_Vendas',
            'S',
            'Executado com sucesso, por m sem novos registros'
        )
    END

END TRY
BEGIN CATCH
    INSERT INTO Datawarehouse_TechSales..Admin_Log
        (processo, status, mensagem)
    VALUES (
        'load_fato_Vendas',
        'F',
        CONCAT(
            'Erro: ',   ERROR_MESSAGE(),
            ' Linha: ', ERROR_LINE()
        )
    )
END CATCH
GO

-- ============================================

-- Como executar todas na ordem correta
EXEC load_dim_Tempo
GO
EXEC load_dim_Cliente
GO
EXEC load_dim_Produto
GO
EXEC load_dim_Vendedor
GO
EXEC load_fato_Vendas
GO

SELECT * FROM dim_Cliente
GO
SELECT * FROM dim_Produto
GO
SELECT * FROM dim_Vendedor
GO
SELECT * FROM dim_Tempo
GO
SELECT * FROM fato_Vendas
GO

SELECT * FROM Admin_Log ORDER BY data_log DESC
GO