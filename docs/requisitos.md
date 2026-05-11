# 📋 Requisitos — TechSales Ltda

## 🏢 Contexto da Empresa
A **TechSales Ltda** é uma distribuidora de produtos de tecnologia 
(notebooks, periféricos, softwares e acessórios) que atende clientes 
Pessoa Física e Pessoa Jurídica em todo o Brasil. Opera com equipe de 
vendedores internos e externos, divididos por regiões, e trabalha com 
fornecedores que abastecem o estoque de produtos revendidos.

## 😤 Problema Identificado
A empresa controlava tudo em planilhas Excel descentralizadas por 
vendedor, causando:
- Números inconsistentes entre áreas
- Demora de dias para consolidar informações
- Impossibilidade de análise em tempo real
- Falta de visibilidade sobre estoque, metas e desempenho

---

## ✅ REQUISITOS FUNCIONAIS

### 👤 Clientes
| Código | Requisito | Atendido | Como foi atendido |
|---|---|---|---|
| RF01 | Cadastrar clientes PF e PJ | ✅ | campo tipo_cliente CHAR(2) |
| RF02 | CPF ou CNPJ nunca os dois | ✅ | CK_Cliente_Tipo + CK_Cliente_CpfCnpj |
| RF03 | Apenas um contato principal | ✅ | email e telefone na própria tabela |
| RF04 | Múltiplos endereços | ✅ | tabela cadastro.Endereco_Cliente |
| RF05 | Segmento obrigatório | ✅ | segmento VARCHAR NOT NULL |
| RF06 | Soft delete | ✅ | campo ativo BIT NOT NULL DEFAULT 1 |

### 📦 Produtos
| Código | Requisito | Atendido | Como foi atendido |
|---|---|---|---|
| RF07 | Produto pertence a subcategoria e categoria | ✅ | FK id_subcategoria → Sub_Categoria → Categoria |
| RF08 | Um único fornecedor principal | ✅ | FK id_fornecedor NOT NULL |
| RF09 | Preço custo e venda separados | ✅ | preco_custo e preco_venda DECIMAL(15,2) |
| RF10 | Variações como produtos distintos | ✅ | cada variação é um registro separado |
| RF11 | Soft delete | ✅ | campo ativo BIT NOT NULL DEFAULT 1 |
| RF12 | Estoque atual e mínimo | ✅ | estoque_atual INT DEFAULT 0 e estoque_minimo INT |

### 🏭 Fornecedores
| Código | Requisito | Atendido | Como foi atendido |
|---|---|---|---|
| RF13 | CNPJ, contato e endereços | ✅ | tabelas cadastro.Fornecedor e cadastro.Endereco_Fornecedor |

### 👨‍💼 Vendedores
| Código | Requisito | Atendido | Como foi atendido |
|---|---|---|---|
| RF14 | Cargo obrigatório | ✅ | cargo VARCHAR NOT NULL |
| RF15 | Região principal | ✅ | FK id_regiao NOT NULL |
| RF16 | Histórico de regiões | ✅ | tabela vendas.Vendedor_Regiao com data_inicio e data_fim |
| RF17 | Atender fora da região | ✅ | sem restrição de região no pedido |
| RF18 | Hierarquia gerente | ✅ | auto-relacionamento id_gerente → id_vendedor |
| RF19 | Gerente sem meta | ✅ | CK_Meta_Sem_Gerente |

### 🛒 Pedidos
| Código | Requisito | Atendido | Como foi atendido |
|---|---|---|---|
| RF20 | Um cliente e um vendedor | ✅ | FKs id_cliente e id_vendedor NOT NULL |
| RF21 | Mínimo um item | ⚠️ | não garantível via constraint — validação na aplicação |
| RF22 | Status, frete, pagamento | ✅ | todos os campos presentes com CHECK |
| RF23 | Uma forma de pagamento | ✅ | campo único forma_pagamento com CHECK |
| RF24 | Endereço de entrega do cliente | ✅ | FK id_endereco_entrega → Endereco_Cliente |
| RF25 | Motivo cancelamento obrigatório | ✅ | CK_Pedido_Motivo_Cancelamento |
| RF26 | Cancelado não baixa estoque | ✅ | TR_Bloqueia_Movimentacao_Cancelado |

### 🧾 Itens do Pedido
| Código | Requisito | Atendido | Como foi atendido |
|---|---|---|---|
| RF27 | Produto, quantidade, preço e desconto | ✅ | todos os campos presentes |
| RF28 | Preço fixado no momento da venda | ✅ | preco_unitario no Item_Pedido separado do Produto |
| RF29 | Flag desconto acima de 30% | ✅ | aprovacao_desconto BIT + CK_Item_Aprovacao_Desconto |

### 📦 Estoque
| Código | Requisito | Atendido | Como foi atendido |
|---|---|---|---|
| RF30 | Entrada, Saída e Ajuste | ✅ | CK_Movimentacao_Tipo |
| RF31 | Responsável e data | ✅ | id_vendedor NOT NULL e data_movimentacao DATETIME |
| RF32 | Vinculada a pedido, fornecedor ou avulsa | ✅ | id_pedido e id_fornecedor NULL |
| RF33 | Depósito único | ✅ | sem tabela de depósito |

### 🎯 Metas
| Código | Requisito | Atendido | Como foi atendido |
|---|---|---|---|
| RF34 | Metas mensais por vendedor | ✅ | campo periodo DATE |
| RF35 | Histórico preservado | ✅ | UNIQUE (id_vendedor, periodo) |
| RF36 | Gerente sem meta | ✅ | CK_Meta_Sem_Gerente |

---

## ⚙️ REQUISITOS NÃO FUNCIONAIS

| Código | Requisito | Atendido | Como foi atendido |
|---|---|---|---|
| RNF01 | SQL Server | ✅ | banco TechSales no SQL Server |
| RNF02 | Soft delete | ✅ | flag ativo em Cliente, Produto e Vendedor |
| RNF03 | Preço imutável após registro | ✅ | preco_unitario no Item_Pedido |
| RNF04 | Rastreabilidade | ✅ | id_vendedor e datas em movimentações |

---