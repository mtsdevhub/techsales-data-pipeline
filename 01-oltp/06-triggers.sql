-- TRIGGERS
-- Quando inserir um item em Movimentacao_Estoque o estoque_atual do produto precisa ser atualizado automaticamente.

	CREATE OR ALTER TRIGGER TR_Movimentacao_Atualiza_Estoque
	ON estoque.Movimentacao_Estoque
	AFTER INSERT
	AS
	BEGIN
    -- Entrada → soma no estoque
    UPDATE estoque.Produto
    SET estoque_atual = estoque_atual + i.quantidade
    FROM estoque.Produto p
    INNER JOIN inserted i ON p.id_produto = i.id_produto
    WHERE i.tipo_movimentacao = 'Entrada'

    -- Saída → subtrai do estoque
    UPDATE estoque.Produto
    SET estoque_atual = estoque_atual - i.quantidade
    FROM estoque.Produto p
    INNER JOIN inserted i ON p.id_produto = i.id_produto
    WHERE i.tipo_movimentacao = 'Saida'

    -- Ajuste → pode ser positivo ou negativo
    -- depende da regra de negócio
	END

-- ===============================================================================================

--	Bloquear movimentação de pedido cancelado

	CREATE OR ALTER TRIGGER TR_Bloqueia_Movimentacao_Cancelado
	ON estoque.Movimentacao_Estoque
	AFTER INSERT
	AS
	BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN comercial.Pedido p ON i.id_pedido = p.id_pedido
        WHERE p.[status] = 'Cancelado'
    )
    BEGIN
        RAISERROR('Pedido cancelado não pode gerar movimentação de estoque!', 16, 1)
        ROLLBACK TRANSACTION
    END
	END