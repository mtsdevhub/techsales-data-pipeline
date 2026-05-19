## 📏 REGRAS DE NEGÓCIO

| Código | Regra | Atendido | Como foi atendido |
|---|---|---|---|
| RN01 | Pedido tem 1 ou vários produtos | ✅ | tabela comercial.Item_Pedido |
| RN02 | Pedido tem 1 cliente e 1 vendedor | ✅ | FKs NOT NULL em Pedido |
| RN03 | Preço imutável na venda | ✅ | preco_unitario no Item_Pedido |
| RN04 | Produto → subcategoria → categoria | ✅ | FKs em cascata |
| RN05 | Um fornecedor por produto | ✅ | FK id_fornecedor NOT NULL |
| RN06 | Estoque atualizado por movimentação | ✅ | TR_Movimentacao_Atualiza_Estoque |
| RN07 | Cancelado não baixa estoque | ✅ | TR_Bloqueia_Movimentacao_Cancelado |
| RN08 | Gerente sem meta | ✅ | CK_Meta_Sem_Gerente |
| RN09 | Cliente PF ou PJ exclusivo | ✅ | CK_Cliente_Tipo + CK_Cliente_CpfCnpj |
| RN10 | Pedido com mínimo 1 item | ⚠️ | não garantível via constraint — validação na aplicação |
| RN11 | Desconto máximo 30% com flag | ✅ | CK_Item_Aprovacao_Desconto |
| RN12 | Movimentação com tipo e responsável | ✅ | tipo NOT NULL e id_vendedor NOT NULL |
| RN13 | Vendedor tem região principal | ✅ | id_regiao NOT NULL em Vendedor |
| RN14 | Histórico de regiões | ✅ | vendas.Vendedor_Regiao com data_inicio e data_fim |
| RN15 | Hierarquia gerente | ✅ | auto-relacionamento id_gerente → id_vendedor |
| RN16 | Soft delete | ✅ | campo ativo nas tabelas principais |
| RN17 | Cancelado registra motivo | ✅ | CK_Pedido_Motivo_Cancelamento |
| RN18 | Endereço de entrega do cliente | ✅ | FK id_endereco_entrega → Endereco_Cliente |
| RN19 | Movimentação vinculada ou avulsa | ✅ | FKs id_pedido e id_fornecedor nullable |
| RN20 | Depósito único | ✅ | sem tabela de depósito |

---

## 🎯 NECESSIDADES ANALÍTICAS — futuro BI

| Código | Indicador | Atendido |
|---|---|---|
| BI01 | Faturamento por período, região, categoria e vendedor | ✅ vw_Faturamento_Por_Vendedor |
| BI02 | Ticket médio por cliente e por pedido | ✅ query 3.3 |
| BI03 | Ranking de produtos mais vendidos e lucrativos | ✅ queries 3.4 e 4.3 |
| BI04 | Desempenho dos vendedores vs meta | ✅ vw_Desempenho_Vendedor + SP_Desempenho_Vendedor |
| BI05 | Taxa de cancelamento de pedidos | ✅ query 1.3 |
| BI06 | Giro de estoque por produto | ✅ query 3.4 |
| BI07 | Clientes inativos há mais de 90 dias | ✅ query 4.4 |

---

## ⚠️ PENDÊNCIAS

| Código | Descrição | Motivo |
|---|---|---|
| RF21 | Pedido com mínimo 1 item | Não é possível garantir via constraint no SQL Server — requer trigger ou validação na aplicação |
| RN10 | Pedido com mínimo 1 item | Idem RF21 |
| RN06 | Ajuste de estoque positivo/negativo | Regra de negócio não definida para movimentações do tipo Ajuste |