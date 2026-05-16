-- ============================================
-- Procedimento para carregar os dados do banco de origem (TechSales_OLTP) para as tabelas de stage (Stage_TechSales)
-- ============================================
CREATE OR ALTER PROCEDURE Carrega_Stage_TechSales
AS
BEGIN TRY

    -- Contadores por tabela
    DECLARE @TotalClientes   INT = 0
    DECLARE @TotalProdutos   INT = 0
    DECLARE @TotalVendedores INT = 0
    DECLARE @TotalVendas     INT = 0
    DECLARE @TotalItens      INT = 0

    -- ============================================
    -- Limpa o Stage para nova carga
    -- ============================================
    TRUNCATE TABLE stg_Clientes
    TRUNCATE TABLE stg_Produtos
    TRUNCATE TABLE stg_Vendedores
    TRUNCATE TABLE stg_Vendas
    TRUNCATE TABLE stg_Itens_Pedido

    -- ============================================
    -- Carga stg_Clientes
    -- ============================================
    INSERT INTO Stage_TechSales..stg_Clientes (
        CodOrigemCliente,
        TipoCliente,
        NomeCliente,
        CpfCnpjCliente,
        EmailCliente,
        TelefoneCliente,
        SegmentoCliente,
        DataCadastroCliente,
        StatusCliente,
        TipoEnderecoCliente,
        LogradouroEnderecoCliente,
        NumeroEnderecoCliente,
        ComplementoEnderecoCliente,
        BairroEnderecoCliente,
        CidadeEnderecoCliente,
        EstadoEnderecoCliente,
        CepEnderecoCliente
    )
    SELECT
        CodOrigemCliente,
        TipoCliente,
        NomeCliente,
        CpfCnpjCliente,
        EmailCliente,
        TelefoneCliente,
        SegmentoCliente,
        DataCadastroCliente,
        StatusCliente,
        TipoEnderecoCliente,
        LogradouroEnderecoCliente,
        NumeroEnderecoCliente,
        ComplementoEnderecoCliente,
        BairroEnderecoCliente,
        CidadeEnderecoCliente,
        EstadoEnderecoCliente,
        CepEnderecoCliente
    FROM TechSales.dbo.vw_Extracao_Clientes
    SET @TotalClientes = @@ROWCOUNT

    -- ============================================
    -- Carga stg_Produtos
    -- ============================================
    INSERT INTO Stage_TechSales..stg_Produtos (
        CodOrigemProduto,
        CodFornecedor,
        CodSubCategoria,
        NomeProduto,
        DescricaoProduto,
        PrecoCustoProduto,
        PrecoVendaProduto,
        UnidadeMedidaProduto,
        EstoqueAtualProduto,
        EstoqueMinimoProduto,
        StatusProduto,
        NomeFornecedor,
        CnpjFornecedor,
        EmailFornecedor,
        TelefoneFornecedor,
        NomeSubCategoriaProduto,
        DescricaoSubCategoria,
        NomeCategoriaProduto,
        DescricaoCategoria
    )
    SELECT
        CodOrigemProduto,
        CodFornecedor,
        CodSubCategoria,
        NomeProduto,
        DescricaoProduto,
        PrecoCustoProduto,
        PrecoVendaProduto,
        UnidadeMedidaProduto,
        EstoqueAtualProduto,
        EstoqueMinimoProduto,
        StatusProduto,
        NomeFornecedor,
        CnpjFornecedor,
        EmailFornecedor,
        TelefoneFornecedor,
        NomeSubCategoriaProduto,
        DescricaoSubCategoria,
        NomeCategoriaProduto,
        DescricaoCategoria
    FROM TechSales.dbo.vw_Extracao_Produtos
    SET @TotalProdutos = @@ROWCOUNT

    -- ============================================
    -- Carga stg_Vendedores
    -- ============================================
    INSERT INTO Stage_TechSales..stg_Vendedores (
        CodOrigemVendedor,
        CodRegiao,
        NomeVendedor,
        NomeGerente,
        CpfVendedor,
        EmailVendedor,
        TelefoneVendedor,
        CargoVendedor,
        DataAdmissaoVendedor,
        StatusVendedor,
        NomeRegiaoVendedor,
        DescricaoRegiao
    )
    SELECT
        CodOrigemVendedor,
        CodRegiao,
        NomeVendedor,
        NomeGerente,
        CpfVendedor,
        EmailVendedor,
        TelefoneVendedor,
        CargoVendedor,
        DataAdmissaoVendedor,
        StatusVendedor,
        NomeRegiaoVendedor,
        DescricaoRegiao
    FROM TechSales.dbo.vw_Extracao_Vendedores
    SET @TotalVendedores = @@ROWCOUNT

    -- ============================================
    -- Carga stg_Vendas
    -- ============================================
    INSERT INTO Stage_TechSales..stg_Vendas (
        CodOrigemPedido,
        CodCliente,
        CodVendedor,
        CodEnderecoEntrega,
        DataPedido,
        StatusPedido,
        MotivoCancelamento,
        TipoFrete,
        ValorFrete,
        DescontoPedido,
        FormaPagamento,
        CondicaoPagamento,
        ObservacaoPedido,
        DataAtualizacaoPedido,
        QuantidadeItens,
        ValorBruto,
        ValorLiquido
    )
    SELECT
        CodOrigemPedido,
        CodCliente,
        CodVendedor,
        CodEnderecoEntrega,
        DataPedido,
        StatusPedido,
        MotivoCancelamento,
        TipoFrete,
        ValorFrete,
        DescontoPedido,
        FormaPagamento,
        CondicaoPagamento,
        ObservacaoPedido,
        DataAtualizacaoPedido,
        QuantidadeItens,
        ValorBruto,
        ValorLiquido
    FROM TechSales.dbo.vw_Extracao_Vendas
    SET @TotalVendas = @@ROWCOUNT

    -- ============================================
    -- Carga stg_Itens_Pedido
    -- ============================================
    INSERT INTO Stage_TechSales..stg_Itens_Pedido (
        CodOrigemItem,
        CodPedido,
        CodProduto,
        QuantidadeItem,
        PrecoUnitarioItem,
        DescontoItem,
        AprovacaoDesconto,
        DataPedido,
        StatusPedido,
        DescontoPedido,
        ValorBruto,
        ValorLiquido,
        LucroBruto
    )
    SELECT
        CodOrigemItem,
        CodPedido,
        CodProduto,
        QuantidadeItem,
        PrecoUnitarioItem,
        DescontoItem,
        AprovacaoDesconto,
        DataPedido,
        StatusPedido,
        DescontoPedido,
        ValorBruto,
        ValorLiquido,
        LucroBruto
    FROM TechSales.dbo.vw_Extracao_Itens_Pedido
    SET @TotalItens = @@ROWCOUNT

    -- ============================================
    -- Log de sucesso com totais por tabela
    -- ============================================
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'Carrega_Stage_TechSales',
        'S',
        CONCAT(
            'Carga realizada com sucesso! ',
            'Clientes: ',   @TotalClientes,   ' | ',
            'Produtos: ',   @TotalProdutos,   ' | ',
            'Vendedores: ', @TotalVendedores, ' | ',
            'Vendas: ',     @TotalVendas,     ' | ',
            'Itens: ',      @TotalItens
        )
    )

END TRY
BEGIN CATCH

    -- ============================================
    -- Log de erro com detalhes
    -- ============================================
    INSERT INTO Admin_Log (processo, status, mensagem)
    VALUES (
        'Carrega_Stage_TechSales',
        'F',
        CONCAT(
            'Erro: ',   ERROR_MESSAGE(),
            ' Linha: ', ERROR_LINE()
        )
    )

END CATCH
GO