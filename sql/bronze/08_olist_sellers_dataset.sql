-- =====================================================
-- BRONZE: olist_sellers_dataset
-- =====================================================
-- Grão: 1 linha por seller.
-- PK lógica: seller_id.
-- Origem: olist_sellers_dataset.csv.
--
-- Esta tabela é a base de DIM_SELLER e da subdimensão
-- DIM_SELLER_LOCATION (README define hierarquia
-- região -> estado -> cidade a partir daqui).
-- =====================================================

CREATE TABLE IF NOT EXISTS seller_ops_mart.bronze.olist_sellers_dataset (
  seller_id               STRING,  -- identificador único do seller
  seller_zip_code_prefix  BIGINT,  -- prefixo do CEP do seller (ajustar tipo na silver)
  seller_city             STRING,  -- cidade do seller
  seller_state            STRING   -- estado (UF) do seller
)
USING DELTA
COMMENT 'Sellers crus do dataset Olist - camada bronze (base de DIM_SELLER / DIM_SELLER_LOCATION)';
