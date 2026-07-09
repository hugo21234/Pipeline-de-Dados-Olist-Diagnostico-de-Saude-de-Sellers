# SQL — Camada Bronze

Esta pasta contém o DDL da camada **bronze** do `SELLER_OPS_MART`, seguindo o
princípio de medallion: **uma tabela por arquivo de origem**, sem joins, sem
agregações e sem transformação — apenas o dado cru, como veio do dataset
[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

## Por que arquivos separados por tabela

Cada arquivo documenta, junto ao `CREATE TABLE`, o **grão** e a **PK lógica**
daquela tabela em comentários. Isso é intencional: em bronze, a garantia mais
importante não é performance, é a capacidade de **reler exatamente o que veio
da fonte** sem reprocessar a ingestão. Uma tabela por CSV torna essa garantia
explícita e auditável arquivo por arquivo.

## Ordem de execução

Rode os scripts nesta ordem (o `00` cria o catalog/schema; os demais podem
rodar em qualquer ordem entre si, pois bronze não impõe FK física):

| Ordem | Arquivo | Tabela | Grão |
|---|---|---|---|
| 00 | `bronze/00_criar_catalog_schema.sql` | catalog `seller_ops_mart` + schema `bronze` | — |
| 01 | `bronze/01_olist_customers_dataset.sql` | `olist_customers_dataset` | 1 linha por cliente |
| 02 | `bronze/02_olist_geolocation_dataset.sql` | `olist_geolocation_dataset` | 1 linha por CEP + coordenada |
| 03 | `bronze/03_olist_order_items_dataset.sql` | `olist_order_items_dataset` | 1 linha por item de pedido |
| 04 | `bronze/04_olist_order_payments_dataset.sql` | `olist_order_payments_dataset` | 1 linha por parcela/pagamento |
| 05 | `bronze/05_olist_order_reviews_dataset.sql` | `olist_order_reviews_dataset` | 1 linha por review |
| 06 | `bronze/06_olist_orders_dataset.sql` | `olist_orders_dataset` | 1 linha por pedido |
| 07 | `bronze/07_olist_products_dataset.sql` | `olist_products_dataset` | 1 linha por produto |
| 08 | `bronze/08_olist_sellers_dataset.sql` | `olist_sellers_dataset` | 1 linha por seller |
| 09 | `bronze/09_product_category_name_translation.sql` | `product_category_name_translation` | 1 linha por categoria |

## Caminho lógico completo

Todas as tabelas ficam sob `seller_ops_mart.bronze.<nome_da_tabela>`, por exemplo:

```
seller_ops_mart.bronze.olist_orders_dataset
seller_ops_mart.bronze.olist_sellers_dataset
```

## SQL — Camada Silver

A pasta `sql/silver/` contém o DDL da camada **silver** do `SELLER_OPS_MART`:
dado limpo, renomeado para PT-BR e padronizado a partir da bronze, ainda no
grão original de cada entidade (não é o modelo estrela final — isso fica
para a camada mart).

| Ordem | Arquivo | Tabela | Fonte (bronze) | Transformação principal |
|---|---|---|---|---|
| 00 | `silver/00_criar_schema_silver.sql` | schema `silver` | — | cria o schema |
| 01 | `silver/01_itens_pedidos.sql` | `Itens_Pedidos` | `olist_order_items_dataset` | renomeação de colunas para PT-BR |
| 02 | `silver/02_olist_orders.sql` | `Olist_orders` | `olist_orders_dataset` | renomeação de colunas para PT-BR |
| 03 | `silver/03_geolocalizacao.sql` | `geolocalizacao` | `olist_geolocation_dataset` | padronização do nome do município via `CASE` (centenas de variações de grafia/acento) |
| 04 | `silver/04_olist_cliente.sql` | `OLIST_Cliente` | `olist_customers_dataset` | desnormalização do grão para `customer_unique_id` (1 linha por cliente, via `GROUP BY` + `ANY_VALUE`) |

Caminho lógico completo: `seller_ops_mart.silver.<nome_da_tabela>`.

## Próximos passos (mart)

Esta pasta cobre bronze e silver. A próxima camada, ainda a criar:

- `sql/mart/` — `F_SELLER_ORDERS`, `F_SELLER_REVIEWS`, `DIM_SELLER`,
  `DIM_SELLER_LOCATION`, `DIM_PRODUCT`, `DIM_PRODUCT_CATEGORY`, `DIM_TIME` e
  o agregado `AGG_SELLER_HEALTH`, conforme desenhado no [README principal](../README.md)
  do projeto.
