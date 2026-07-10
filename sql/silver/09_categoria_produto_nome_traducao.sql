-- Silver Layer: Tradução e correção de nomes de categorias de produto
-- Fonte: seller_ops_mart.bronze.product_category_name_translation
-- Correções aplicadas: typos nos nomes em inglês (home_confort, fashio_female_clothing, costruction_tools_*)

CREATE OR REPLACE TABLE categoria_produto_nome_traducao AS
SELECT
    product_category_name AS nome_da_categoria_do_produto,
    CASE
        WHEN product_category_name_english = 'home_confort'              THEN 'home_comfort'
        WHEN product_category_name_english = 'fashio_female_clothing'    THEN 'fashion_female_clothing'
        WHEN product_category_name_english = 'costruction_tools_tools'   THEN 'construction_tools_tools'
        WHEN product_category_name_english = 'costruction_tools_garden'  THEN 'construction_tools_garden'
        ELSE product_category_name_english
    END AS nome_ingles_da_categoria_do_produto

FROM seller_ops_mart.bronze.product_category_name_translation;
