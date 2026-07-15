# Pipeline de Dados Olist — Diagnóstico de Saúde de Sellers

Este projeto constrói um data mart em Snowflake Schema a partir do dataset público da Olist, focado em diagnóstico de saúde de sellers. A modelagem foi orientada por perguntas reais de operação: quem fatura mais/menos, quais sellers combinam atraso com notas ruins e quais cidades concentram mais sellers e maior faturamento.

Ao longo do desenvolvimento, utilizei assistência de IA como ferramenta de apoio em engenharia de dados: identificação de deduplicações e anomalias, revisão de integridade entre camadas (Bronze → Silver → Data Mart) e suporte na definição de métricas de negócio. A IA foi usada para aumentar produtividade e agilizar processos de ingestão e modelagem, mas todas as decisões de design, regras de negócio e SQL foram revisadas e implementadas manualmente.

---

## Dashboard — Visão Geral

![Dashboard Preview](assets/dashboard_preview.jpg)

---

## Visão geral

Este projeto define e implementa um **data mart de operações de sellers** (SELLER_OPS_MART) em cima do dataset público da Olist.

O objetivo não é modelar "todo" o data warehouse da Olist, mas criar um recorte específico que atenda ao time de operações e qualidade de sellers, usando **Snowflake Schema** para representar hierarquias de localização e categorias de produtos.

---

## Problema de negócio

A Olist depende da performance dos sellers para manter a experiência do cliente. Alguns vendedores atrasam entregas, concentram reclamações e derrubam a nota média da plataforma.

Este mart responde às perguntas:

- Quais sellers são de alto risco para a plataforma?
- Quais sellers combinam atraso com nota ruim simultaneamente?
- Em quais cidades os sellers estão concentrados e qual o faturamento por cidade?
- Quem fatura mais e quem fatura menos?

O consumidor direto desse mart é o time de **Seller Operations**, que precisa decidir quem treinar, monitorar ou eventualmente desligar.

---

## Dataset de origem

Fonte principal: **Brazilian E-Commerce Public Dataset by Olist (Kaggle)**.

Tabelas relevantes ingeridas na camada Bronze:

- `orders` — status, datas de compra, aprovação, envio e entrega
- `order_items` — itens por pedido, `seller_id`, preço, frete
- `order_reviews` — notas (1–5) e comentários
- `order_payments` — forma de pagamento, parcelas
- `sellers` — localização do seller (cidade, estado)
- `customers` — localização do cliente
- `products` — categoria, dimensões
- `product_category_translation` — tradução de categorias
- `geolocation` — CEP, latitude, longitude

---

## Arquitetura Medallion

O projeto segue a arquitetura em três camadas:

```
Bronze (CSVs crus do Olist)
    ↓
Silver (tabelas normalizadas e limpas)
    ↓
Data Mart (SELLER_OPS_MART — fatos, dimensões e views)
```

- **Bronze**: ingestão bruta dos 9 CSVs do dataset Olist, sem transformações.
- **Silver**: limpeza, padronização de nomes, deduíplicação e normalização de geolocalização.
- **Data Mart**: modelagem dimensional orientada ao domínio de operações de sellers.

---

## Desafios enfrentados

### Desafio 1 — Geolocalização suja e redundante

O dataset de geolocação da Olist contém múltiplas entradas para o mesmo CEP com variações de grafia (cidades em minúsculo, maiúsculo, com e sem acento). Sem tratamento, o join com sellers ficaria ambíguo e geraria fanout nas métricas.

**Solução implementada:** padronização de `cidade_padronizada` e `estado_padronizado` na camada Silver (`03_geolocalizacao.sql`), com agregação por `GROUP BY` para eliminar duplicatas antes de qualquer join.

---

### Desafio 2 — Modelo de geolocação acoplado

A versão inicial da `dim_seller` referenciava diretamente a tabela `sellers_geolacation` (nome incorreto, sem normalização). Isso criava acoplamento direto entre a dimensão de seller e a tabela de geolocação, impossibilitando reuso em outros marts.

**Solução implementada:** desmembramento em duas subdimensões:
- `dim_localidade` — tabela mestre de combinações únicas `estado + cidade`
- `dim_seller_geolocation` — liga cada prefixo de CEP à sua `localidade_id`

A `dim_seller` passou a referenciar `dim_seller_geolocation` via `geolocation_id`, criando a hierarquia: `dim_seller → dim_seller_geolocation → dim_localidade`.

---

### Desafio 3 — Métricas de risco não existiam no dataset

O dataset não fornece diretamente um indicador de risco por seller. Era preciso derivar isso a partir de métricas brutas de pedidos e avaliações.

**Solução implementada:** criação de um índice composto na `vw_analise_sellers_performance`:

```
índice_performance_ruim = (média_dias_atraso × 0.5) + ((5 − média_nota) × 2)
```

Quanto maior o índice, pior o seller. A view filtra apenas sellers com mínimo de 5 pedidos para evitar ruído estatístico.

---

### Desafio 4 — Integridade referencial entre fatos e dimensões

Sem constraints explicitadas, os joins entre `fact_pedidos`, `dim_seller` e as subdimensões de geolocação poderiam silenciosamente perder registros ou gerar duplicatas.

**Solução implementada:** definição explícita de PRIMARY KEY em `dim_seller_geolocation`, FOREIGN KEY de `dim_seller` para `dim_seller_geolocation`, e FOREIGN KEY de `fact_pedidos` para `dim_seller_geolocation` via `seller_location_id`.

---

## O que foi implementado

### Camada Bronze — Ingestão

| Arquivo | Tabela |
|--------|--------|
| `00_criar_catalog_schema.sql` | Criação do catalog e schema |
| `01_olist_customers_dataset.sql` | customers |
| `02_olist_geolocation_dataset.sql` | geolocation |
| `03_olist_order_items_dataset.sql` | order_items |
| `04_olist_order_payments_dataset.sql` | order_payments |
| `05_olist_order_reviews_dataset.sql` | order_reviews |
| `06_olist_orders_dataset.sql` | orders |
| `07_olist_products_dataset.sql` | products |
| `08_olist_sellers_dataset.sql` | sellers |
| `09_product_category_name_translation.sql` | category_translation |

### Camada Silver — Transformação

| Arquivo | Tabela |
|--------|--------|
| `00_criar_schema_silver.sql` | Criação do schema silver |
| `01_itens_pedidos.sql` | itens_pedidos |
| `02_olist_orders.sql` | olist_orders |
| `03_geolocalizacao.sql` | geolocalizacao (padronizada) |
| `04_olist_cliente.sql` | olist_cliente |
| `05_olist_pagamentos.sql` | olist_pagamentos |
| `06_olist_avaliacao.sql` | avalicao |
| `07_vendedores.sql` | vendedores |
| `08_olist_produto.sql` | olist_produto |
| `09_categoria_produto_nome_traducao.sql` | categoria_produto_nome_traducao |

### Camada Data Mart — Modelagem Dimensional

| Arquivo | O que faz |
|--------|----------|
| `01_dim_seller_not_null.sql` | Constraint NOT NULL em dim_seller |
| `02_dim_seller_fk_geolocation.sql` | FK legacy (sellers_geolacation) |
| `03_dim_seller_ctas.sql` | `dim_seller` — dimensão de sellers com FK para geolocation |
| `04_sub_dim_categoria_pk_fk.sql` | PK/FK da subdimensão de categoria |
| `05_dim_time_ctas.sql` | `dim_time` — dimensão de tempo |
| `06_fact_pedidos_ctas.sql` | `fact_pedidos` — tabela fato de pedidos com métricas de atraso |
| `07_audit_constraints.sql` | Auditoria de constraints do mart |
| `08_fact_reviews_ctas.sql` | `fact_reviews` — tabela fato de avaliações |
| `09_vw_analise_sellers_performance.sql` | View: índice de performance ruim por seller |
| `10_dim_localidade_ctas.sql` | `dim_localidade` — tabela mestre de cidade + estado |
| `11_dim_seller_geolocation_ctas.sql` | `dim_seller_geolocation` — CEP linkado à localidade |
| `12_vw_performance_negativa_sellers.sql` | View: sellers com atraso e/ou nota ruim por pedido |
| `13_vw_faturamento_por_cidade.sql` | View: faturamento total agregado por cidade |
| `14_fk_fact_pedidos_seller_geolocation.sql` | FK de fact_pedidos para dim_seller_geolocation |
| `15_pk_fk_dim_seller_geolocation.sql` | PK em dim_seller_geolocation + FK de dim_seller |

---

## Snowflake Schema — Hierarquia de dimensões

```
fact_pedidos
    ├── dim_seller
    │       └── dim_seller_geolocation
    │               └── dim_localidade (cidade + estado)
    ├── dim_product
    │       └── sub_dim_categoria
    └── dim_time

fact_reviews
    ├── fact_pedidos (via order_id)
    └── dim_time
```

---

## Views analíticas

### `vw_analise_sellers_performance`
Combina métricas de atraso e avaliação por seller. Calcula o `indice_performance_ruim` como indicador composto de risco. Filtra sellers com menos de 5 pedidos.

### `vw_performance_negativa_sellers`
Classifica cada pedido como `CRÍTICO: Atraso + Nota Ruim`, `Pedido Atrasado`, `Nota Ruim` ou `OK`. Alimenta o painel de sellers problemáticos do dashboard.

### `vw_faturamento_por_cidade`
Agrega faturamento, ticket médio, total de pedidos e sellers por cidade. Percorre a hierarquia completa: `fact_pedidos → dim_seller → dim_seller_geolocation → dim_localidade`.

---

## Ordem de execução

A ordem abaixo deve ser respeitada por dependência entre tabelas:

```
1. Bronze (00 → 09)
2. Silver (00 → 09)
3. Data Mart:
   a. dim_time
   b. sub_dim_categoria
   c. dim_localidade
   d. dim_seller_geolocation
   e. dim_seller
   f. fact_pedidos
   g. fact_reviews
   h. Constraints e FKs (07, 14, 15)
   i. Views (09, 12, 13)
```

---

## Mentalidade

Este projeto não é sobre "fazer mais tabelas".

É sobre aprender a pensar em termos de **domínios de dados, contratos e modelos que resistem à mudança** — subindo do nível de tabelas soltas para data products com integridade referencial, hierarquias documentadas e perguntas de negócio respondidas de forma reproduzível.
