-- =====================================================
-- BRONZE: olist_geolocation_dataset
-- =====================================================
-- Grão: 1 linha por combinação de CEP + lat/lng reportada
-- (não é único por CEP - pode haver múltiplas coordenadas
-- para o mesmo prefixo de CEP).
-- PK lógica: não há PK única natural; é uma tabela de apoio
-- geográfico, não uma dimensão pronta.
-- Origem: olist_geolocation_dataset.csv.
-- =====================================================

CREATE TABLE IF NOT EXISTS seller_ops_mart.bronze.olist_geolocation_dataset (
  geolocation_zip_code_prefix  BIGINT,  -- prefixo do CEP
  geolocation_lat               DOUBLE,  -- latitude
  geolocation_lng               DOUBLE,  -- longitude
  geolocation_city              STRING,  -- cidade associada ao CEP
  geolocation_state             STRING   -- estado (UF) associado ao CEP
)
USING DELTA
COMMENT 'Geolocalização crua (CEP -> lat/lng) do dataset Olist - camada bronze';
