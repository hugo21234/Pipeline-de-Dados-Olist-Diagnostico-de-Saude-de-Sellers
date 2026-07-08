-- =====================================================
-- BRONZE: olist_customers_dataset
-- =====================================================
-- Grão: 1 linha por cliente (customer_id).
-- PK lógica: customer_id.
-- Origem: olist_customers_dataset.csv (dataset Olist / Kaggle).
--
-- Observação: customer_zip_code_prefix é tratado como BIGINT
-- porque veio assim do upload, mas conceitualmente é um código
-- (string). Isso deve ser corrigido na camada silver.
-- =====================================================

CREATE TABLE IF NOT EXISTS seller_ops_mart.bronze.olist_customers_dataset (
  customer_id               STRING,  -- identificador do pedido do cliente (muda a cada pedido)
  customer_unique_id        STRING,  -- identificador estável do cliente entre pedidos diferentes
  customer_zip_code_prefix  BIGINT,  -- prefixo do CEP do cliente (ajustar tipo na silver)
  customer_city             STRING,  -- cidade do cliente
  customer_state            STRING   -- estado (UF) do cliente
)
USING DELTA
COMMENT 'Clientes crus do dataset Olist - camada bronze';
