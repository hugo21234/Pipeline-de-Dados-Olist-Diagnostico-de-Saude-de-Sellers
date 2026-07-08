-- =====================================================
-- BRONZE: olist_order_payments_dataset
-- =====================================================
-- Grão: 1 linha por parcela/registro de pagamento de um pedido
-- (um pedido pode ter mais de um método/parcela de pagamento).
-- PK lógica: (order_id, payment_sequential).
-- Origem: olist_order_payments_dataset.csv.
--
-- Não é usada diretamente pelos fatos F_SELLER_ORDERS /
-- F_SELLER_REVIEWS do README, mas fica disponível em bronze
-- para eventuais análises de pagamento por seller.
-- =====================================================

CREATE TABLE IF NOT EXISTS seller_ops_mart.bronze.olist_order_payments_dataset (
  order_id              STRING,  -- FK lógica para olist_orders_dataset
  payment_sequential    BIGINT,  -- ordem do pagamento dentro do pedido (1, 2, 3...)
  payment_type          STRING,  -- tipo de pagamento (boleto, cartão de crédito, etc.)
  payment_installments  BIGINT,  -- número de parcelas
  payment_value         DOUBLE   -- valor pago naquela parcela/registro
)
USING DELTA
COMMENT 'Pagamentos de pedidos crus do dataset Olist - camada bronze';
