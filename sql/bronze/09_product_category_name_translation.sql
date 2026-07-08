-- =====================================================
-- BRONZE: product_category_name_translation
-- =====================================================
-- Grão: 1 linha por categoria de produto (mapeamento
-- português -> inglês).
-- PK lógica: product_category_name.
-- Origem: product_category_name_translation.csv.
--
-- Alimenta a subdimensão DIM_PRODUCT_CATEGORY do README,
-- que também tem uma coluna derivada (category_group) não
-- presente na fonte - essa derivação acontece na silver/mart,
-- não aqui em bronze.
-- =====================================================

CREATE TABLE IF NOT EXISTS seller_ops_mart.bronze.product_category_name_translation (
  product_category_name          STRING,  -- nome da categoria em português (chave lógica)
  product_category_name_english  STRING   -- nome da categoria em inglês
)
USING DELTA
COMMENT 'Tradução de categorias de produto (PT -> EN) do dataset Olist - camada bronze (base de DIM_PRODUCT_CATEGORY)';
