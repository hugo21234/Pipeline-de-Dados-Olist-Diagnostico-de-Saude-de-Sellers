-- =====================================================
-- BRONZE: olist_order_items_dataset
-- =====================================================
-- Grão: 1 linha por item dentro de um pedido.
-- PK lógica: (order_id, order_item_id).
-- Origem: olist_order_items_dataset.csv.
--
-- Esta tabela é a ponte entre pedidos (orders) e sellers,
-- pois é aqui que aparece o seller_id de quem vendeu o item.
-- É insumo direto do fato F_SELLER_ORDERS.
-- =====================================================

CREATE TABLE IF NOT EXISTS seller_ops_mart.bronze.olist_order_items_dataset (
  order_id             STRING,     -- FK lógica para olist_orders_dataset
  order_item_id        BIGINT,     -- número sequencial do item dentro do pedido
  product_id           STRING,     -- FK lógica para olist_products_dataset
  seller_id            STRING,     -- FK lógica para olist_sellers_dataset
  shipping_limit_date  TIMESTAMP,  -- prazo limite para o seller despachar o item
  price                DOUBLE,     -- preço do item (sem frete)
  freight_value        DOUBLE      -- valor do frete daquele item
)
USING DELTA
COMMENT 'Itens de pedido crus do dataset Olist - camada bronze (1 linha por item por pedido)';
