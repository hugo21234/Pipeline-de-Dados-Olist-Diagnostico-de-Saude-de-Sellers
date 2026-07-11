CREATE OR REPLACE TABLE Dim_seller AS
SELECT 
    s.vendedor_id,
    CASE 
        WHEN s.prefix_cep_norm IS NULL THEN 'EM BRANCO' 
        ELSE s.prefix_cep_norm 
    END AS prefix_cep_norm
FROM seller_ops_mart.silver.vendedores AS s
LEFT JOIN seller_ops_mart.data_mart.sellers_geolacation AS sg
    ON s.prefix_cep_norm = CAST(sg.CEP_PREFIXO AS STRING);
