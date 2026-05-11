--	NÍVEL 5 — VIEWS
--  Faturamento total e quantidade de pedidos por vendedor

	CREATE OR ALTER VIEW vendas.vw_Faturamento_Por_Vendedor
	AS
	SELECT v.nome_vendedor AS Vendedor,
	COUNT(DISTINCT p.id_pedido) AS QuantidadePedido,
	SUM(i.quantidade * i.preco_unitario * (1 - ISNULL(i.desconto_item, 0) / 100.0)) AS Faturamento 
	FROM vendas.Vendedor v
	INNER JOIN comercial.Pedido p ON v.id_vendedor = p.id_vendedor
	INNER JOIN comercial.item_pedido i  ON p.id_pedido =  i.id_pedido
	WHERE p.[status] != 'Cancelado'
	GROUP BY v.nome_vendedor 

	SELECT * FROM vendas.vw_Faturamento_Por_Vendedor
	ORDER BY Faturamento DESC
	
-- ===============================================================================================

-- Produtos com estoque abaixo do mínimo

	CREATE OR ALTER VIEW estoque.vw_Estoque_Critico
	AS
	SELECT 
    p.nome_produto,
    p.estoque_atual,
    p.estoque_minimo,
    p.estoque_minimo - p.estoque_atual AS QuantidadeRepor,
    f.razao_social                     AS Fornecedor,
    f.email                            AS ContatoFornecedor
	FROM estoque.Produto p
	INNER JOIN cadastro.Fornecedor f ON p.id_fornecedor = f.id_fornecedor
	WHERE p.estoque_atual < p.estoque_minimo 

	SELECT * FROM estoque.vw_Estoque_Critico

-- ===============================================================================================

-- Vendedor, meta do mês, faturamento real, % atingido
	CREATE OR ALTER VIEW vendas.vw_Desempenho_Vendedor
	AS
	SELECT
    v.nome_vendedor,
	m.periodo,
    MAX(m.valor_meta)                                           AS Meta,
    SUM(i.quantidade * i.preco_unitario * 
        (1 - ISNULL(i.desconto_item, 0) / 100.0))              AS Faturamento,
    SUM(i.quantidade * i.preco_unitario * 
        (1 - ISNULL(i.desconto_item, 0) / 100.0))
        - MAX(m.valor_meta)                                     AS DiferencaMeta,
    ROUND(SUM(i.quantidade * i.preco_unitario * 
        (1 - ISNULL(i.desconto_item, 0) / 100.0))
        / MAX(m.valor_meta) * 100, 2)                          AS PercAtingido
	FROM vendas.Vendedor v
	INNER JOIN vendas.Meta  m           ON v.id_vendedor = m.id_vendedor
	INNER JOIN comercial.Pedido p      ON v.id_vendedor = p.id_vendedor
		AND MONTH(p.data_pedido) = MONTH(m.periodo)
		AND YEAR(p.data_pedido)  = YEAR(m.periodo)
	INNER JOIN comercial.Item_Pedido i ON i.id_pedido   = p.id_pedido
	WHERE p.[status] != 'Cancelado'
	GROUP BY v.nome_vendedor, m.periodo

	-- Todos os períodos
	SELECT * FROM vendas.vw_Desempenho_Vendedor
	ORDER BY periodo, PercAtingido DESC
	-- Filtrar Janeiro/2024
	SELECT * FROM vendas.vw_Desempenho_Vendedor
	WHERE periodo = '2024-01-01'
	ORDER BY PercAtingido DESC
	-- Filtrar um vendedor específico
	SELECT * FROM vendas.vw_Desempenho_Vendedor
	WHERE nome_vendedor = 'João Silva'
	ORDER BY periodo

-- ===============================================================================================

-- Pedido com cliente, vendedor, itens e valor total
	CREATE OR ALTER VIEW comercial.vw_Pedidos_Completo
	AS
	SELECT
	p2.id_pedido,
	P2.data_pedido,
	p2.[status],
	p2.forma_pagamento,
	p2.tipo_frete,
	p2.valor_frete,
	c.nome_razao_social AS Cliente,
	v.nome_vendedor AS Vendedor,
	p.nome_produto AS Produto,
	i.quantidade,
	i.preco_unitario,
	ISNULL(i.desconto_item, 0) AS Desconto,
	i.quantidade * i.preco_unitario AS ValorBruto,
    i.quantidade * i.preco_unitario * 
        (1 - ISNULL(i.desconto_item, 0) / 100.0) AS ValorLiquido
	FROM comercial.Item_Pedido i
	INNER JOIN estoque.Produto p ON i.id_produto = p.id_produto
	INNER JOIN comercial.Pedido p2 ON p2.id_pedido = i.id_pedido
	INNER JOIN cadastro.Cliente c ON c.id_cliente = p2.id_cliente
	INNER JOIN vendas.Vendedor v ON v.id_vendedor = p2.id_vendedor
	
	
	SELECT * FROM comercial.vw_Pedidos_Completo
	ORDER BY ValorLiquido DESC

-- ===============================================================================================