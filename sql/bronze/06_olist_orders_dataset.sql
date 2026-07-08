-- =====================================================
-- BRONZE: olist_orders_dataset
-- =====================================================
-- Grão: 1 linha por pedido.
-- PK lógica: order_id.
-- Origem: olist_orders_dataset.csv.
--
-- É a tabela raiz do domínio de pedidos. Combinada com
-- order_items, alimenta o fato F_SELLER_ORDERS (o README
-- restringe o grão do fato a pedidos com status "delivered").
-- Aqui, em bronze, guardamos TODOS os status, sem filtro.
-- =====================================================

CREATE TABLE IF NOT EXISTS seller_ops_mart.bronze.olist_orders_dataset (
  order_id                       STRING,     -- identificador único do pedido
  customer_id                    STRING,     -- FK lógica para olist_customers_dataset
  order_status                   STRING,     -- status do pedido (delivered, shipped, canceled, etc.)
  order_purchase_timestamp       TIMESTAMP,  -- data/hora da compra
  order_approved_at              TIMESTAMP,  -- data/hora da aprovação do pagamento
  order_delivered_carrier_date   TIMESTAMP,  -- data/hora em que a transportadora recebeu o pedido
  order_delivered_customer_date  TIMESTAMP,  -- data/hora em que o pedido chegou ao cliente
  order_estimated_delivery_date  TIMESTAMP   -- data estimada de entrega (usada para calcular atraso)
)
USING DELTA
COMMENT 'Pedidos crus do dataset Olist - camada bronze (base para F_SELLER_ORDERS)';
