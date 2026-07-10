-- Silver Layer: Normalização e padronização da tabela de vendedores
-- Fonte: seller_ops_mart.bronze.olist_sellers_dataset
-- Transformações: LPAD no CEP (garantia de 5 dígitos), UPPER na cidade

CREATE OR REPLACE TABLE vendedores AS
SELECT
    seller_id                                           AS vendedor_id,
    LPAD(CAST(seller_zip_code_prefix AS STRING), 5, '0') AS prefix_cep_norm,
    UPPER(seller_city)                                  AS cidade,
    seller_state                                        AS estado

FROM seller_ops_mart.bronze.olist_sellers_dataset;
