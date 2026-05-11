-- ============================================
-- INSERTS — TechSales OLTP
-- ============================================

-- ============================================
-- 1. estoque.Categoria
-- ============================================
INSERT INTO estoque.Categoria (nome_categoria, descricao) VALUES
('Notebooks', 'Computadores portáteis'),
('Periféricos', 'Dispositivos externos para computadores'),
('Softwares', 'Licenças e programas'),
('Redes', 'Equipamentos de conectividade'),
('Acessórios', 'Acessórios diversos de tecnologia');
GO

-- ============================================
-- 2. estoque.Sub_Categoria
-- ============================================
INSERT INTO estoque.Sub_Categoria (id_categoria, nome_subcategoria, descricao) VALUES
(1, 'Notebooks Gamer', 'Notebooks para jogos de alta performance'),
(1, 'Notebooks Corporativos', 'Notebooks para uso empresarial'),
(1, 'Notebooks Ultrabooks', 'Notebooks finos e leves'),
(2, 'Mouses', 'Mouses com fio e sem fio'),
(2, 'Teclados', 'Teclados mecânicos e de membrana'),
(2, 'Monitores', 'Monitores LED e IPS'),
(3, 'Antivírus', 'Softwares de segurança'),
(3, 'Pacotes Office', 'Suítes de escritório'),
(4, 'Roteadores', 'Equipamentos de roteamento'),
(4, 'Switches', 'Switches de rede'),
(5, 'Cabos', 'Cabos HDMI, USB e outros'),
(5, 'Mochilas', 'Mochilas para notebooks');
GO

-- ============================================
-- 3. cadastro.Fornecedor
-- ============================================
INSERT INTO cadastro.Fornecedor (razao_social, cnpj, email, telefone) VALUES
('Dell Technologies Brasil Ltda', '72381189000110', 'vendas@dell.com.br', '1132180000'),
('Logitech do Brasil Ltda', '54485045000168', 'contato@logitech.com.br', '1140030000'),
('Microsoft Brasil Ltda', '60316817000144', 'vendas@microsoft.com.br', '1137213200'),
('TP-Link Brasil Ltda', '17347661000120', 'suporte@tp-link.com.br', '1132830000'),
('Multilaser Industrial SA', '61724781000147', 'comercial@multilaser.com.br', '1143260000');
GO

-- ============================================
-- 4. cadastro.Endereco_Fornecedor
-- ============================================
INSERT INTO cadastro.Endereco_Fornecedor (id_fornecedor, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
(1, 'Av Doutor Chucri Zaidan', '940', '10 andar', 'Vila Cordeiro', 'São Paulo', 'SP', '04583110'),
(2, 'Rua Funchal', '418', '5 andar', 'Vila Olímpia', 'São Paulo', 'SP', '04551060'),
(3, 'Av das Nações Unidas', '12901', 'Torre Norte', 'Brooklin', 'São Paulo', 'SP', '04578000'),
(4, 'Rua Verbo Divino', '1356', 'Sala 3', 'Chácara Santo Antônio', 'São Paulo', 'SP', '04719002'),
(5, 'Rua Itapeva', '286', NULL, 'Bela Vista', 'São Paulo', 'SP', '01332000');
GO

-- ============================================
-- 5. estoque.Produto
-- ============================================
INSERT INTO estoque.Produto (id_fornecedor, id_subcategoria, nome_produto, descricao, preco_custo, preco_venda, unidade_medida, estoque_atual, estoque_minimo, ativo) VALUES
(1, 1, 'Notebook Dell G15 RTX 3050', 'Notebook gamer 15 pol Intel i5 16GB RAM 512GB SSD', 3200.00, 4599.00, 'UN', 15, 3, 1),
(1, 2, 'Notebook Dell Latitude 5420', 'Notebook corporativo 14 pol Intel i7 16GB RAM 256GB SSD', 4100.00, 5999.00, 'UN', 10, 2, 1),
(1, 3, 'Notebook Dell XPS 13', 'Ultrabook 13 pol Intel i7 16GB RAM 512GB SSD', 5500.00, 7999.00, 'UN', 8, 2, 1),
(2, 4, 'Mouse Logitech MX Master 3', 'Mouse sem fio ergonômico 4000 DPI', 280.00, 499.00, 'UN', 40, 10, 1),
(2, 5, 'Teclado Logitech MX Keys', 'Teclado sem fio retroiluminado', 350.00, 599.00, 'UN', 30, 8, 1),
(2, 6, 'Monitor LG 27 4K IPS', 'Monitor 27 pol 4K resolução IPS', 1800.00, 2799.00, 'UN', 12, 3, 1),
(3, 7, 'Antivírus Kaspersky 1 ano', 'Licença antivírus 1 dispositivo 1 ano', 80.00, 149.00, 'LIC', 100, 20, 1),
(3, 8, 'Microsoft Office 365 Business', 'Licença anual Office 365 para empresas', 350.00, 599.00, 'LIC', 80, 15, 1),
(4, 9, 'Roteador TP-Link Archer AX73', 'Roteador Wi-Fi 6 AX5400', 450.00, 799.00, 'UN', 20, 5, 1),
(4, 10, 'Switch TP-Link 24 portas', 'Switch gerenciável 24 portas Gigabit', 800.00, 1299.00, 'UN', 10, 2, 1),
(5, 11, 'Cabo HDMI 2.0 2m', 'Cabo HDMI 2.0 suporte 4K 2 metros', 25.00, 59.00, 'UN', 150, 30, 1),
(5, 12, 'Mochila Multilaser para Notebook 15', 'Mochila resistente para notebook até 15 pol', 60.00, 129.00, 'UN', 50, 10, 1),
(1, 2, 'Notebook Dell Latitude 7420', 'Notebook corporativo premium', 5200.00, 7499.00, 'UN', 1, 5, 1),
(2, 4, 'Mouse Logitech G502', 'Mouse gamer 25600 DPI', 200.00, 379.00, 'UN', 2, 10, 1),
(4, 9, 'Roteador TP-Link AX55', 'Roteador Wi-Fi 6 AX3000', 380.00, 649.00, 'UN', 0, 3, 1),
('1', '1', 'Notebook Dell Descontinuado', 'Modelo antigo descontinuado', 2000.00, 2999.00, 'UN', 0, 2, 0);
GO

-- ============================================
-- 6. vendas.Regiao
-- ============================================
INSERT INTO vendas.Regiao (nome_regiao, descricao) VALUES
('Norte', 'Estados da região Norte do Brasil'),
('Nordeste', 'Estados da região Nordeste do Brasil'),
('Centro-Oeste', 'Estados da região Centro-Oeste do Brasil'),
('Sudeste', 'Estados da região Sudeste do Brasil'),
('Sul', 'Estados da região Sul do Brasil');
GO

-- ============================================
-- 7. vendas.Vendedor
-- ============================================
INSERT INTO vendas.Vendedor (id_gerente, id_regiao, nome_vendedor, cpf, email, telefone, cargo, data_admissao, ativo) VALUES
(NULL, 4, 'Ricardo Mendes', '11122233344', 'ricardo@techsales.com.br', '11987650001', 'Gerente', '2019-03-01', 1),
(NULL, 5, 'Fernanda Costa', '22233344455', 'fernanda@techsales.com.br', '51987650002', 'Gerente', '2019-06-01', 1),
(1, 4, 'João Silva', '33344455566', 'joao@techsales.com.br', '11987650003', 'Sênior', '2020-01-15', 1),
(1, 4, 'Maria Santos', '44455566677', 'maria@techsales.com.br', '11987650004', 'Pleno', '2021-03-10', 1),
(1, 3, 'Carlos Oliveira', '55566677788', 'carlos@techsales.com.br', '62987650005', 'Júnior', '2022-07-01', 1),
(2, 5, 'Ana Souza', '66677788899', 'ana@techsales.com.br', '51987650006', 'Sênior', '2020-05-20', 1),
(2, 1, 'Pedro Lima', '77788899900', 'pedro@techsales.com.br', '92987650007', 'Pleno', '2021-08-01', 1),
(2, 2, 'Juliana Rocha', '88899900011', 'juliana@techsales.com.br', '81987650008', 'Júnior', '2023-01-10', 1),
(1, 4, 'Marcos Inativo', '99988877766', 'marcos@techsales.com.br', '11987650009', 'Júnior', '2021-01-10', 0);
GO

-- ============================================
-- 8. vendas.Vendedor_Regiao
-- ============================================
INSERT INTO vendas.Vendedor_Regiao (id_vendedor, id_regiao, data_inicio, data_fim) VALUES
(1, 4, '2019-03-01', NULL),
(2, 5, '2019-06-01', NULL),
(3, 4, '2020-01-15', NULL),
(4, 4, '2021-03-10', NULL),
(5, 4, '2022-07-01', '2023-06-30'),
(5, 3, '2023-07-01', NULL),
(6, 5, '2020-05-20', NULL),
(7, 1, '2021-08-01', NULL),
(8, 2, '2023-01-10', NULL),
(9, 4, '2021-01-10', '2023-12-31');
GO

-- ============================================
-- 9. vendas.Meta
-- ============================================
INSERT INTO vendas.Meta (id_vendedor, periodo, valor_meta) VALUES
(3, '2024-01-01', 50000.00),
(3, '2024-02-01', 50000.00),
(3, '2024-03-01', 55000.00),
(4, '2024-01-01', 35000.00),
(4, '2024-02-01', 35000.00),
(4, '2024-03-01', 40000.00),
(5, '2024-01-01', 25000.00),
(5, '2024-02-01', 25000.00),
(5, '2024-03-01', 30000.00),
(6, '2024-01-01', 45000.00),
(6, '2024-02-01', 45000.00),
(6, '2024-03-01', 50000.00),
(7, '2024-01-01', 30000.00),
(7, '2024-02-01', 30000.00),
(7, '2024-03-01', 35000.00),
(8, '2024-01-01', 20000.00),
(8, '2024-02-01', 20000.00),
(8, '2024-03-01', 25000.00);
GO

-- ============================================
-- 10. cadastro.Cliente
-- ============================================
INSERT INTO cadastro.Cliente (tipo_cliente, nome_razao_social, cpf_cnpj, email, telefone, segmento, data_cadastro, ativo) VALUES
('PJ', 'Tech Corp Soluções Ltda', '12345678000190', 'compras@techcorp.com.br', '1132001000', 'Corporativo', '2022-01-10', 1),
('PJ', 'Escola Digital SA', '98765432000121', 'ti@escoladigital.com.br', '1133002000', 'Educacional', '2022-03-15', 1),
('PJ', 'Prefeitura de Campinas', '56789012000133', 'licitacao@campinas.sp.gov.br', '1934003000', 'Governo', '2022-06-20', 1),
('PF', 'Bruno Almeida', '12345678901', 'bruno@email.com', '11987001001', 'Varejo', '2023-01-05', 1),
('PF', 'Carla Ferreira', '98765432100', 'carla@email.com', '11987001002', 'Varejo', '2023-02-14', 1),
('PJ', 'Inova Tech Ltda', '11223344000155', 'ti@inovatech.com.br', '1135004000', 'Corporativo', '2023-03-01', 1),
('PJ', 'Clínica Saúde Digital', '99887766000177', 'sistemas@clinicasd.com.br', '1136005000', 'Corporativo', '2023-05-10', 1),
('PF', 'Diego Martins', '11122233300', 'diego@email.com', '11987001003', 'Varejo', '2023-07-22', 1),
('PJ', 'Universidade Livre SP', '44556677000188', 'compras@univlivre.edu.br', '1137006000', 'Educacional', '2023-09-01', 1),
('PF', 'Elaine Gomes', '55566677700', 'elaine@email.com', '11987001004', 'Varejo', '2024-01-10', 1),
('PF', 'Roberto Inativo', '33311122200', 'roberto@email.com', '11987002001', 'Varejo', '2022-05-10', 0),
('PJ', 'Empresa Inativa Ltda', '33445566000199', 'contato@inativa.com.br', '1138007000', 'Corporativo', '2021-08-15', 0),
('PF', 'Lucas Sem Pedido', '44433322211', 'lucas@email.com', '11987003001', 'Varejo', '2024-02-01', 1),
('PJ', 'Startup Sem Pedido Ltda', '77665544000122', 'contato@startup.com.br', '1139008000', 'Corporativo', '2024-03-01', 1);
GO

-- ============================================
-- 11. cadastro.Endereco_Cliente
-- ============================================
INSERT INTO cadastro.Endereco_Cliente (id_cliente, tipo_endereco, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
(1, 'Principal', 'Av Paulista', '1000', 'Andar 5', 'Bela Vista', 'São Paulo', 'SP', '01310100'),
(1, 'Entrega', 'Rua Augusta', '500', 'Sala 2', 'Consolação', 'São Paulo', 'SP', '01305000'),
(2, 'Principal', 'Rua das Flores', '200', NULL, 'Centro', 'São Paulo', 'SP', '01010010'),
(3, 'Principal', 'Av Anchieta', '200', NULL, 'Centro', 'Campinas', 'SP', '13015904'),
(4, 'Principal', 'Rua das Palmeiras', '45', 'Apto 12', 'Moema', 'São Paulo', 'SP', '04077000'),
(5, 'Principal', 'Av Brasil', '789', NULL, 'Jardins', 'São Paulo', 'SP', '01430001'),
(6, 'Principal', 'Rua Vergueiro', '3185', 'Conj 42', 'Vila Mariana', 'São Paulo', 'SP', '04101300'),
(6, 'Entrega', 'Av Santo Amaro', '1000', NULL, 'Santo Amaro', 'São Paulo', 'SP', '04506001'),
(7, 'Principal', 'Rua Oscar Freire', '110', NULL, 'Cerqueira César', 'São Paulo', 'SP', '01426001'),
(8, 'Principal', 'Rua Gomes de Carvalho', '1306', 'Apto 3', 'Vila Olímpia', 'São Paulo', 'SP', '04547005'),
(9, 'Principal', 'Av Prof Luciano Gualberto', '315', NULL, 'Butantã', 'São Paulo', 'SP', '05508010'),
(10, 'Principal', 'Rua Haddock Lobo', '595', 'Apto 21', 'Cerqueira César', 'São Paulo', 'SP', '01414003'),
(13, 'Principal', 'Rua Nova', '300', NULL, 'Pinheiros', 'São Paulo', 'SP', '05422000'),
(14, 'Principal', 'Av Rebouças', '1000', 'Sala 5', 'Pinheiros', 'São Paulo', 'SP', '05402100'),
(11, 'Principal', 'Rua Inativa', '100', NULL, 'Centro', 'São Paulo', 'SP', '01001000'),
(12, 'Principal', 'Av Inativa', '200', NULL, 'Centro', 'São Paulo', 'SP', '01002000');
GO

-- ============================================
-- 12. comercial.Pedido
-- ============================================
INSERT INTO comercial.Pedido (id_cliente, id_vendedor, id_endereco_entrega, data_pedido, [status], motivo_cancelamento, tipo_frete, valor_frete, desconto_pedido, forma_pagamento, condicao_pagamento, observacoes, data_atualizacao) VALUES
(1, 3, 2, '2024-01-10', 'Entregue', NULL, 'CIF', 0.00, 5.00, 'Boleto', '30 dias', NULL, '2024-01-20'),
(2, 4, 3, '2024-01-15', 'Entregue', NULL, 'CIF', 0.00, NULL, 'PIX', 'A vista', NULL, '2024-01-22'),
(3, 3, 4, '2024-01-20', 'Entregue', NULL, 'FOB', 150.00, 3.00, 'Transferencia', '30 dias', 'Pedido urgente', '2024-02-01'),
(4, 5, 5, '2024-02-01', 'Entregue', NULL, 'FOB', 30.00, NULL, 'Cartao', 'A vista', NULL, '2024-02-05'),
(5, 4, 6, '2024-02-10', 'Cancelado', 'Cliente desistiu da compra', 'FOB', 30.00, NULL, 'PIX', 'A vista', NULL, '2024-02-10'),
(6, 3, 8, '2024-02-15', 'Entregue', NULL, 'CIF', 0.00, 10.00, 'Boleto', '60 dias', NULL, '2024-02-28'),
(7, 6, 9, '2024-02-20', 'Enviado', NULL, 'CIF', 0.00, NULL, 'Boleto', '30 dias', NULL, '2024-02-22'),
(1, 3, 1, '2024-03-01', 'Aprovado', NULL, 'CIF', 0.00, 5.00, 'Boleto', '90 dias', NULL, '2024-03-01'),
(9, 7, 11, '2024-03-05', 'Entregue', NULL, 'CIF', 0.00, 8.00, 'Transferencia', '30 dias', NULL, '2024-03-15'),
(10, 8, 12, '2024-03-10', 'Aguardando', NULL, 'FOB', 25.00, NULL, 'PIX', 'A vista', NULL, '2024-03-10'),
(1, 3, 1, '2024-01-25', 'Entregue', NULL, 'CIF', 0.00, NULL, 'Boleto', '30 dias', NULL, '2024-02-05'),
(6, 4, 7, '2024-01-28', 'Entregue', NULL, 'CIF', 0.00, NULL, 'PIX', 'A vista', NULL, '2024-02-01'),
(9, 7, 11, '2024-01-20', 'Entregue', NULL, 'CIF', 0.00, NULL, 'Transferencia', '30 dias', NULL, '2024-01-30'),
(4, 3, 5, '2023-06-01', 'Entregue', NULL, 'FOB', 30.00, NULL, 'PIX', 'A vista', NULL, '2023-06-05'),
(5, 4, 6, '2023-05-15', 'Entregue', NULL, 'FOB', 30.00, NULL, 'Boleto', '30 dias', NULL, '2023-05-20'),
(8, 5, 10, '2023-07-10', 'Entregue', NULL, 'FOB', 25.00, NULL, 'Cartao', 'A vista', NULL, '2023-07-15');
GO

-- ============================================
-- 13. comercial.Item_Pedido
-- ============================================
INSERT INTO comercial.Item_Pedido (id_pedido, id_produto, quantidade, preco_unitario, desconto_item, aprovacao_desconto) VALUES
(1, 1, 2, 4599.00, 5.00, 0),
(1, 4, 2, 499.00, NULL, 0),
(2, 7, 10, 149.00, 10.00, 0),
(2, 8, 5, 599.00, 10.00, 0),
(3, 9, 3, 799.00, NULL, 0),
(3, 10, 2, 1299.00, NULL, 0),
(4, 4, 1, 499.00, NULL, 0),
(4, 11, 3, 59.00, NULL, 0),
(5, 5, 1, 599.00, NULL, 0),
(6, 2, 3, 5999.00, 35.00, 1),
(6, 6, 2, 2799.00, NULL, 0),
(7, 8, 8, 599.00, 15.00, 0),
(8, 1, 5, 4599.00, 5.00, 0),
(8, 3, 2, 7999.00, NULL, 0),
(9, 7, 20, 149.00, 10.00, 0),
(9, 8, 10, 599.00, 10.00, 0),
(10, 12, 2, 129.00, NULL, 0),
(10, 11, 5, 59.00, NULL, 0),
(14, 1, 5, 4599.00, NULL, 0),
(14, 2, 3, 5999.00, NULL, 0),
(15, 8, 10, 599.00, 10.00, 0),
(15, 7, 15, 149.00, NULL, 0),
(16, 9, 4, 799.00, NULL, 0),
(16, 10, 2, 1299.00, NULL, 0),
(11, 4, 1, 499.00, NULL, 0),
(12, 5, 1, 599.00, NULL, 0),
(13, 11, 2, 59.00, NULL, 0);
GO

-- ============================================
-- 14. estoque.Movimentacao_Estoque
-- ============================================
INSERT INTO estoque.Movimentacao_Estoque (id_produto, id_pedido, id_fornecedor, id_vendedor, tipo_movimentacao, quantidade, data_movimentacao, observacao) VALUES
(1, NULL, 1, 1, 'Entrada', 20, '2024-01-01', 'Compra inicial fornecedor Dell'),
(4, NULL, 2, 1, 'Entrada', 50, '2024-01-01', 'Compra inicial fornecedor Logitech'),
(7, NULL, 3, 1, 'Entrada', 120, '2024-01-01', 'Compra inicial fornecedor Microsoft'),
(1, 1, NULL, 3, 'Saida', 2, '2024-01-10', 'Saida por venda pedido 1'),
(4, 1, NULL, 3, 'Saida', 2, '2024-01-10', 'Saida por venda pedido 1'),
(7, 2, NULL, 4, 'Saida', 10, '2024-01-15', 'Saida por venda pedido 2'),
(8, 2, NULL, 4, 'Saida', 5, '2024-01-15', 'Saida por venda pedido 2'),
(9, 3, NULL, 3, 'Saida', 3, '2024-01-20', 'Saida por venda pedido 3'),
(10, 3, NULL, 3, 'Saida', 2, '2024-01-20', 'Saida por venda pedido 3'),
(4, 4, NULL, 5, 'Saida', 1, '2024-02-01', 'Saida por venda pedido 4'),
(2, NULL, 1, 1, 'Entrada', 15, '2024-02-01', 'Reposição fornecedor Dell'),
(2, 6, NULL, 3, 'Saida', 3, '2024-02-15', 'Saida por venda pedido 6'),
(1, NULL, NULL, 1, 'Ajuste', 3, '2024-02-20', 'Ajuste de inventário'),
(8, 7, NULL, 6, 'Saida', 8, '2024-02-20', 'Saida por venda pedido 7'),
(7, 9, NULL, 7, 'Saida', 20, '2024-03-05', 'Saida por venda pedido 9'),
(4, 11, NULL, 3, 'Saida', 1, '2023-06-01', 'Saida por venda pedido 11'),
(5, 12, NULL, 4, 'Saida', 1, '2023-05-15', 'Saida por venda pedido 12'),
(11, 13, NULL, 5, 'Saida', 2, '2023-07-10', 'Saida por venda pedido 13'),
(1, 14, NULL, 3, 'Saida', 5, '2024-01-25', 'Saida por venda pedido 14'),
(2, 14, NULL, 3, 'Saida', 3, '2024-01-25', 'Saida por venda pedido 14'),
(8, 15, NULL, 4, 'Saida', 10, '2024-01-28', 'Saida por venda pedido 15'),
(7, 15, NULL, 4, 'Saida', 15, '2024-01-28', 'Saida por venda pedido 15'),
(9, 16, NULL, 7, 'Saida', 4, '2024-01-20', 'Saida por venda pedido 16'),
(10, 16, NULL, 7, 'Saida', 2, '2024-01-20', 'Saida por venda pedido 16');
GO