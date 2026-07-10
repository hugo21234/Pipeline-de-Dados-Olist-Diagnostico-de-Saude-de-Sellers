-- Silver Layer: Tipagem e padronização da tabela de produtos
-- Fonte: seller_ops_mart.bronze.olist_products_dataset
-- Transformações: CAST explícito em todas as colunas numéricas, renomeamento para português

CREATE OR REPLACE TABLE silver.olist_produto AS
SELECT
    product_id                                              AS produto_id,
    product_category_name                                   AS produto_categoria,
    CAST(product_name_lenght        AS INT)                 AS produto_nome_tamanho,
    CAST(product_description_lenght AS INT)                 AS produto_descricao_tamanho,
    CAST(product_photos_qty         AS INT)                 AS produto_fotos_quantidade,
    CAST(product_weight_g           AS DOUBLE)              AS produto_peso_gramas,
    CAST(product_length_cm          AS NUMERIC(10, 2))      AS produto_comprimento_cm,
    CAST(product_height_cm          AS NUMERIC(10, 2))      AS produto_altura_cm,
    CAST(product_width_cm           AS NUMERIC(10, 2))      AS produto_largura_cm

FROM seller_ops_mart.bronze.olist_products_dataset;
