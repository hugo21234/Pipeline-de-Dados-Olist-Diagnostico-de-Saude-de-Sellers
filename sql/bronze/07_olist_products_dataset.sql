-- =====================================================
-- BRONZE: olist_products_dataset
-- =====================================================
-- Grão: 1 linha por produto.
-- PK lógica: product_id.
-- Origem: olist_products_dataset.csv.
--
-- Observação: os nomes "product_name_lenght" e
-- "product_description_lenght" têm erro de digitação
-- ("lenght" em vez de "length") - isso vem do próprio CSV
-- de origem. Mantemos igual em bronze (espelho fiel da
-- fonte) e corrigimos o nome apenas na camada silver.
-- =====================================================

CREATE TABLE IF NOT EXISTS seller_ops_mart.bronze.olist_products_dataset (
  product_id                    STRING,  -- identificador único do produto
  product_category_name         STRING,  -- categoria do produto em português (FK lógica para product_category_name_translation)
  product_name_lenght           BIGINT,  -- tamanho do nome do produto (typo herdado do CSV original)
  product_description_lenght    BIGINT,  -- tamanho da descrição do produto (typo herdado do CSV original)
  product_photos_qty            BIGINT,  -- quantidade de fotos do produto
  product_weight_g              BIGINT,  -- peso do produto em gramas
  product_length_cm             BIGINT,  -- comprimento do produto em cm
  product_height_cm             BIGINT,  -- altura do produto em cm
  product_width_cm              BIGINT   -- largura do produto em cm
)
USING DELTA
COMMENT 'Catálogo de produtos cru do dataset Olist - camada bronze';
