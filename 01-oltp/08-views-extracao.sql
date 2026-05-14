-- ============================================
-- VIEWS DE EXTRAÇÃO — TechSales OLTP
-- Objetivo: camada de leitura para carga do Stage
-- ============================================

USE TechSales;
GO

-- ============================================
-- 1. vw_Extracao_Clientes
-- Extrai clientes com endereço principal
-- ============================================
CREATE OR ALTER VIEW vw_Extracao_Clientes AS
SELECT
    c.id_cliente                            AS CodOrigemCliente,
    ISNULL(c.tipo_cliente, '--')            AS TipoCliente,
    c.nome_razao_social                     AS NomeCliente,
    c.cpf_cnpj                              AS CpfCnpjCliente,
    c.email                                 AS EmailCliente,
    c.telefone                              AS TelefoneCliente,
    c.segmento                              AS SegmentoCliente,
    c.data_cadastro                         AS DataCadastroCliente,
    c.ativo                                 AS StatusCliente,
    ISNULL(e.tipo_endereco, '--')           AS TipoEnderecoCliente,
    ISNULL(e.logradouro, '--')              AS LogradouroEnderecoCliente,
    ISNULL(e.numero, '--')                  AS NumeroEnderecoCliente,
    ISNULL(e.complemento, '--')             AS ComplementoEnderecoCliente,
    ISNULL(e.bairro, '--')                  AS BairroEnderecoCliente,
    ISNULL(e.cidade, '--')                  AS CidadeEnderecoCliente,
    ISNULL(e.estado, '--')                  AS EstadoEnderecoCliente,
    ISNULL(e.cep, '--')                     AS CepEnderecoCliente
	FROM cadastro.Cliente AS c
	LEFT JOIN cadastro.Endereco_Cliente AS e
    ON c.id_cliente = e.id_cliente
    AND e.tipo_endereco = 'Principal'
GO

-- ============================================
-- 2. vw_Extracao_Produtos
-- Extrai produtos com categoria e fornecedor
-- ============================================
CREATE OR ALTER VIEW vw_Extracao_Produtos AS
SELECT
    p.id_produto                            AS CodOrigemProduto,
    p.id_fornecedor                         AS CodFornecedor,
    p.id_subcategoria                       AS CodSubCategoria,
    p.nome_produto                          AS NomeProduto,
    ISNULL(p.descricao, '--')               AS DescricaoProduto,
    p.preco_custo                           AS PrecoCustoProduto,
    p.preco_venda                           AS PrecoVendaProduto,
    p.unidade_medida                        AS UnidadeMedidaProduto,
    p.estoque_atual                         AS EstoqueAtualProduto,
    p.estoque_minimo                        AS EstoqueMinimoProduto,
    p.ativo                                 AS StatusProduto,
    f.razao_social                          AS NomeFornecedor,
    f.cnpj                                  AS CnpjFornecedor,
    ISNULL(f.email, '--')                   AS EmailFornecedor,
    ISNULL(f.telefone, '--')                AS TelefoneFornecedor,
    s.nome_subcategoria                     AS NomeSubCategoriaProduto,
    ISNULL(s.descricao, '--')               AS DescricaoSubCategoria,
    c.nome_categoria                        AS NomeCategoriaProduto,
    ISNULL(c.descricao, '--')               AS DescricaoCategoria
	FROM estoque.Produto AS p
	INNER JOIN estoque.Sub_Categoria AS s   ON s.id_subcategoria = p.id_subcategoria
	INNER JOIN estoque.Categoria AS c       ON c.id_categoria    = s.id_categoria
	INNER JOIN cadastro.Fornecedor AS f     ON f.id_fornecedor   = p.id_fornecedor	
GO

-- ============================================
-- 3. vw_Extracao_Vendedores
-- Extrai vendedores com gerente e região
-- ============================================
CREATE OR ALTER VIEW vw_Extracao_Vendedores AS
SELECT
    v.id_vendedor                           AS CodOrigemVendedor,
    v.id_regiao                             AS CodRegiao,
    v.nome_vendedor                         AS NomeVendedor,
    ISNULL(g.nome_vendedor, '--')           AS NomeGerente,
    v.cpf                                   AS CpfVendedor,
    ISNULL(v.email, '--')                   AS EmailVendedor,
    ISNULL(v.telefone, '--')                AS TelefoneVendedor,
    ISNULL(v.cargo, '--')                   AS CargoVendedor,
    v.data_admissao                         AS DataAdmissaoVendedor,
    v.ativo                                 AS StatusVendedor,
    r.nome_regiao                           AS NomeRegiaoVendedor,
    ISNULL(r.descricao, '--')               AS DescricaoRegiao

	FROM vendas.Vendedor AS v
	LEFT JOIN vendas.Vendedor AS g  ON v.id_gerente = g.id_vendedor
	INNER JOIN vendas.Regiao AS r   ON v.id_regiao  = r.id_regiao
GO

-- ============================================
-- 4. vw_Extracao_Vendas
-- Extrai pedidos com totais calculados
-- ============================================
CREATE OR ALTER VIEW vw_Extracao_Vendas AS
SELECT
    p.id_pedido                                             AS CodOrigemPedido,
    p.id_cliente                                            AS CodCliente,
    p.id_vendedor                                           AS CodVendedor,
    p.id_endereco_entrega                                   AS CodEnderecoEntrega,
    p.data_pedido                                           AS DataPedido,
    p.[status]                                              AS StatusPedido,
    ISNULL(p.motivo_cancelamento, '--')                     AS MotivoCancelamento,
    p.tipo_frete                                            AS TipoFrete,
    p.valor_frete                                           AS ValorFrete,
    ISNULL(p.desconto_pedido, 0)                            AS DescontoPedido,
    p.forma_pagamento                                       AS FormaPagamento,
    p.condicao_pagamento                                    AS CondicaoPagamento,
    ISNULL(p.observacoes, '--')                             AS ObservacaoPedido,
    p.data_atualizacao                                      AS DataAtualizacaoPedido,
    SUM(i.quantidade)                                       AS QuantidadeItens,
    SUM(i.quantidade * i.preco_unitario)                    AS ValorBruto,
    SUM(i.quantidade * i.preco_unitario *
        (1 - ISNULL(i.desconto_item, 0) / 100.0))
        * (1 - ISNULL(p.desconto_pedido, 0) / 100.0)       AS ValorLiquido
	FROM comercial.Pedido AS p
	INNER JOIN comercial.Item_Pedido AS i   ON p.id_pedido    = i.id_pedido
	INNER JOIN estoque.Produto AS pr        ON i.id_produto   = pr.id_produto
	GROUP BY
    p.id_pedido,
    p.id_cliente,
    p.id_vendedor,
    p.id_endereco_entrega,
    p.data_pedido,
    p.[status],
    p.motivo_cancelamento,
    p.tipo_frete,
    p.valor_frete,
    p.desconto_pedido,
    p.forma_pagamento,
    p.condicao_pagamento,
    p.observacoes,
    p.data_atualizacao
GO