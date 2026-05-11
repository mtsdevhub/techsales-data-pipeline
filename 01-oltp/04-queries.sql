Use TechSales


-- NÍVEL 1 — SELECT Básico
  -- 1.1 Liste todos os clientes ativos com nome, tipo e segmento
 
	SElECT c.nome_razao_social, c.tipo_cliente, c.segmento
	FROM cadastro.Cliente c
	WHERE ativo = 1;
	go

-- ===============================================================================================

  --1.2 Liste todos os produtos com estoque abaixo do mínimo

	SELECT p.nome_produto, p.estoque_atual, p.estoque_minimo FROM estoque.Produto p
	WHERE p.estoque_atual < p.estoque_minimo 
	go

-- ===============================================================================================

  --1.3 Liste todos os pedidos com status 'Cancelado' e o motivo

	SELECT p.id_pedido, p.data_pedido, p.[status], p.motivo_cancelamento
	FROM comercial.Pedido p
	WHERE [status] = 'Cancelado' 
	go

-- ===============================================================================================

  --1.4 Liste os vendedores e seus cargos ordenados por data de admissão
	SELECT v.nome_vendedor, v.cargo, v.data_admissao
	FROM vendas.Vendedor v
	ORDER BY v.data_admissao ASC --DESC
	go

-- ===============================================================================================

  -- 2.1 Liste todos os pedidos com o nome do cliente e do vendedor responsável

	SELECT 
	c.nome_razao_social as Cliente, 
	v.nome_vendedor as Vendedor, 
	p.id_pedido,
    p.data_pedido,
    p.[status],
    p.forma_pagamento,
    p.valor_frete
	FROM comercial.Pedido p INNER JOIN cadastro.Cliente c ON p.id_cliente = c.id_cliente
	INNER JOIN vendas.Vendedor v ON p.id_vendedor = v.id_vendedor
	go

-- ===============================================================================================

  -- 2.2 Liste todos os produtos com o nome da categoria e subcategoria

	SELECT 
	c.nome_categoria, 
	s.nome_subcategoria, 
	p.nome_produto, 
	p.descricao, 
	p.preco_custo, 
	p.preco_venda
	FROM estoque.Produto p
	INNER JOIN estoque.Sub_Categoria s ON p.id_subcategoria = s.id_subcategoria
	INNER JOIN estoque.Categoria c ON s.id_categoria = c.id_categoria
	ORDER BY c.nome_categoria, s.nome_subcategoria, p.nome_produto
	GO

-- ===============================================================================================

  --  2.3 Liste os itens de cada pedido com nome do produto e valor total do item
	
	SELECT
	i.id_item_pedido,
	i.id_pedido,
	p.nome_produto,
	i.quantidade,
	i.preco_unitario,
	ISNULL(i.desconto_item, 0) AS Desconto,
	i.quantidade * i.preco_unitario AS ValorBruto,
    i.quantidade * i.preco_unitario * 
        (1 - ISNULL(i.desconto_item, 0) / 100.0) AS ValorLiquido
	FROM comercial.Item_Pedido i
	INNER JOIN estoque.Produto p ON i.id_produto = p.id_produto
	
-- ===============================================================================================

  --  2.4 Liste todos os vendedores com o nome do seu gerente
	SELECT 
    v.nome_vendedor AS Vendedor, 
    ISNULL(g.nome_vendedor, 'Sem gerente') AS Gerente, 
    v.cargo
	FROM vendas.Vendedor v
	LEFT JOIN vendas.Vendedor g ON v.id_gerente = g.id_vendedor;
	
-- ===============================================================================================

-- NÍVEL 3 — Agregação e GROUP BY

  --  3.1 Qual o faturamento total por vendedor?

	SELECT v.nome_vendedor AS Vendedor,
	COUNT(DISTINCT p.id_pedido) AS QuantidadePedido,
	SUM(i.quantidade * i.preco_unitario * (1 - ISNULL(i.desconto_item, 0) / 100.0)) AS Faturamento 
	FROM vendas.Vendedor v
	INNER JOIN comercial.Pedido p ON v.id_vendedor = p.id_vendedor
	INNER JOIN comercial.item_pedido i  ON p.id_pedido =  i.id_pedido
	WHERE p.[status] != 'Cancelado'
	GROUP BY v.nome_vendedor 
	ORDER BY Faturamento DESC

-- ===============================================================================================	

  --  3.2 Quantos pedidos cada cliente realizou?

	SELECT
	c.nome_razao_social,
	c.ativo,
	COUNT(DISTINCT p.id_pedido) AS QuantidadePedidos
	FROM comercial.Pedido p
	RIGHT JOIN cadastro.Cliente c ON p.id_cliente = c.id_cliente
	GROUP BY c.nome_razao_social, c.ativo
	ORDER BY QuantidadePedidos DESC

-- ===============================================================================================

  --  3.3 Qual o ticket médio por pedido de cada cliente?
	
	SELECT 
	c.nome_razao_social,
	COUNT(DISTINCT p.id_pedido) AS QuantidadePedido,
	c.ativo,
	SUM(i.quantidade * i.preco_unitario * 
    (1 - ISNULL(i.desconto_item, 0) / 100.0)) 
    / COUNT(DISTINCT p.id_pedido) AS TicketMedio
	FROM cadastro.CLiente c
	INNER JOIN comercial.Pedido p ON c.id_cliente = p.id_cliente
	INNER JOIN comercial.Item_Pedido i ON p.id_pedido = i.id_pedido
	WHERE p.[status] != 'Cancelado'
	GROUP BY c.nome_razao_social, c.ativo

-- ===============================================================================================

  --  3.4 Quais produtos foram mais vendidos em quantidade?

	SELECT 
	p.nome_produto AS NomeProduto,
	SUM(i.quantidade) AS QuantidadeVendida,
	SUM(i.quantidade * i.preco_unitario * (1 - ISNULL(i.desconto_item, 0) / 100.0)) AS FaturamentoProduto
	FROM estoque.Produto p
	INNER JOIN comercial.Item_Pedido i ON p.id_produto = i.id_produto
	INNER JOIN comercial.Pedido pd ON pd.id_pedido = i.id_pedido
	WHERE pd.[status] != 'Cancelado'
	GROUP BY p.nome_produto
	ORDER BY QuantidadeVendida DESC

-- ===============================================================================================

  --  3.5** Qual o faturamento total por mês?

	SELECT
	YEAR(p.data_pedido) AS Ano,
	MONTH(p.data_pedido) AS Mes,
	SUM(i.quantidade * i.preco_unitario * (1 - ISNULL(i.desconto_item, 0) / 100.0)) AS FaturamentoProduto
	FROM comercial.Pedido p
	INNER JOIN comercial.Item_Pedido i ON p.id_pedido = i.id_pedido
	WHERE p.[status] != 'Cancelado'
	GROUP BY YEAR(p.data_pedido), MONTH(p.data_pedido)
	ORDER BY YEAR(p.data_pedido) ASC, MONTH(p.data_pedido) ASC
	
-- ===============================================================================================

--	NÍVEL 4 — Subconsultas e Funções Avançadas

  --  4.1 Liste os clientes que nunca fizeram um pedido
	
	SELECT 
	c.nome_razao_social
	FROM cadastro.Cliente c
	LEFT JOIN comercial.Pedido p 
    ON c.id_cliente = p.id_cliente
    AND p.[status] != 'Cancelado'   
	WHERE p.id_pedido IS NULL
	
-- ===============================================================================================

  --  4.2 Liste os vendedores que bateram a meta em Janeiro/2024
	SELECT
	v.nome_vendedor,
	MAX(m.valor_meta)  AS Meta,
	SUM(i.quantidade * i.preco_unitario * 
	(1 - ISNULL(i.desconto_item, 0) / 100.0)) AS Faturamento,
	SUM(i.quantidade * i.preco_unitario * 
	(1 - ISNULL(i.desconto_item, 0) / 100.0)) 
	- MAX(m.valor_meta) AS DiferencaMeta,
	ROUND(SUM(i.quantidade * i.preco_unitario * 
    (1 - ISNULL(i.desconto_item, 0) / 100.0))
    / MAX(m.valor_meta) * 100, 2) AS PercAtingido
	FROM vendas.Vendedor v
	INNER JOIN vendas.Meta m          ON v.id_vendedor = m.id_vendedor
	INNER JOIN comercial.Pedido p     ON v.id_vendedor = p.id_vendedor
	INNER JOIN comercial.Item_Pedido i ON i.id_pedido  = p.id_pedido
	WHERE m.periodo = '2024-01-01'
	AND MONTH(p.data_pedido) = 1
	AND YEAR(p.data_pedido) = 2024
	AND p.[status] != 'Cancelado'
	GROUP BY v.nome_vendedor
	HAVING SUM(i.quantidade * i.preco_unitario * 
	(1 - ISNULL(i.desconto_item, 0) / 100.0)) >= MAX(m.valor_meta)
	ORDER BY Faturamento DESC
	
-- ===============================================================================================

  --  4.3** Liste os top 3 produtos mais lucrativos
	
	SELECT TOP 3
    p.nome_produto,
    SUM(i.quantidade)   AS QuantidadeVendida,
    SUM((i.preco_unitario * 
        (1 - ISNULL(i.desconto_item, 0) / 100.0) 
        - p.preco_custo) * i.quantidade)  AS Lucro
	FROM estoque.Produto p
	INNER JOIN comercial.Item_Pedido  i  ON p.id_produto = i.id_produto
	INNER JOIN comercial.Pedido  p2 ON p2.id_pedido = i.id_pedido
	WHERE p2.[status] != 'Cancelado'
	GROUP BY p.nome_produto
	ORDER BY Lucro DESC

-- ===============================================================================================

  --  4.4** Liste os clientes inativos há mais de 90 dias
	
	SELECT
    c.nome_razao_social,
    c.ativo,
    MAX(p.data_pedido) AS UltimoPedido,
    DATEDIFF(DAY, MAX(p.data_pedido), GETDATE()) AS DiasInativo
	FROM cadastro.Cliente c
	LEFT JOIN comercial.Pedido  p ON c.id_cliente = p.id_cliente
	WHERE p.[status] != 'Cancelado' OR p.id_pedido IS NULL
	GROUP BY c.nome_razao_social, c.ativo
	HAVING DATEDIFF(DAY, MAX(p.data_pedido), GETDATE()) > 90
    OR MAX(p.data_pedido) IS NULL
	ORDER BY DiasInativo DESC

-- ===============================================================================================
	





