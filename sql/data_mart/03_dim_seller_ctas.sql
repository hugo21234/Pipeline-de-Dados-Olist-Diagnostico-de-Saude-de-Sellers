-- ========================================
-- ATUALIZAÇÃO: DIM_SELLER COM FK PARA GEOLOCATION
-- ========================================
-- Atualiza a dimensão de sellers para usar
-- a nova estrutura normalizada de geolocalizacao
-- Agora usa FK para dim_seller_geolocation


CREATE OR REPLACE TABLE seller_ops_mart.data_mart.dim_seller AS


SELECT 
    s.vendedor_id AS seller_id,
    COALESCE(s.prefix_cep_norm, 'EM BRANCO') AS prefixo_cep,
    sg.seller_geolocation_id AS geolocation_id
    
FROM seller_ops_mart.silver.vendedores s


LEFT JOIN seller_ops_mart.data_mart.dim_seller_geolocation sg
    ON CAST(s.prefix_cep_norm AS STRING) = sg.prefixo_cep
    
ORDER BY s.vendedor_id;
