-- =====================================================
-- CRIAÇÃO DO SCHEMA SILVER
-- =====================================================
-- A camada silver vive no mesmo catalog da bronze
-- (seller_ops_mart), mas em outro schema.
--
-- Bronze  = espelho fiel do CSV, sem transformação.
-- Silver  = dado limpo, padronizado e renomeado para
--           PT-BR, ainda no grão original de cada
--           entidade (não é o modelo estrela final).
-- =====================================================

CREATE SCHEMA IF NOT EXISTS seller_ops_mart.silver
COMMENT 'Camada silver - dados limpos e padronizados a partir da bronze, ainda no grão original de cada entidade Olist';
