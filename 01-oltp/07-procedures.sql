--	 STORED PROCEDURE
-- Relatório de desempenho por período
	CREATE OR ALTER PROCEDURE vendas.SP_Desempenho_Vendedor
    @periodo DATE
	AS
	BEGIN
    SELECT
        v.nome_vendedor,
        MAX(m.valor_meta)                                       AS Meta,
        SUM(i.quantidade * i.preco_unitario *
            (1 - ISNULL(i.desconto_item, 0) / 100.0))          AS Faturamento,
        ROUND(SUM(i.quantidade * i.preco_unitario *
            (1 - ISNULL(i.desconto_item, 0) / 100.0))
            / MAX(m.valor_meta) * 100, 2)                      AS PercAtingido,
        CASE
            WHEN SUM(i.quantidade * i.preco_unitario *
                (1 - ISNULL(i.desconto_item, 0) / 100.0)) 
                >= MAX(m.valor_meta) THEN 'Bateu Meta'
            ELSE 'Abaixo da Meta'
        END                                                     AS Resultado
		FROM vendas.Vendedor AS v
	 INNER JOIN vendas.Meta AS m           ON v.id_vendedor = m.id_vendedor
	 INNER JOIN comercial.Pedido AS p      ON v.id_vendedor = p.id_vendedor
        AND MONTH(p.data_pedido) = MONTH(@periodo)
        AND YEAR(p.data_pedido)  = YEAR(@periodo)
	 INNER JOIN comercial.Item_Pedido AS i ON i.id_pedido = p.id_pedido
		WHERE m.periodo = @periodo
		AND p.[status] != 'Cancelado'
	  GROUP BY v.nome_vendedor
	 ORDER BY PercAtingido DESC
	END

-- Como chamar
EXEC vendas.SP_Desempenho_Vendedor @periodo = '2024-01-01'