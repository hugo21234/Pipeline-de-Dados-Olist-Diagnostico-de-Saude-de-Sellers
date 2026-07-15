-- ========================================
-- SUBDIMENSÃO: SELLER GEOLOCATION (CEP + LOCALIDADE)
-- ========================================
-- Liga cada prefixo de CEP à sua localidade
-- Usa FK para referenciar dim_localidade
-- Cada CEP_PREFIXO recebe um UUID único


CREATE OR REPLACE TABLE seller_ops_mart.data_mart.dim_seller_geolocation AS


SELECT 
    uuid() AS seller_geolocation_id,
    geo.CEP_PREFIXO AS prefixo_cep,
    loc.localidade_id AS localidade_id
    
FROM seller_ops_mart.silver.geolocalizacao geo


INNER JOIN seller_ops_mart.data_mart.dim_localidade loc
    ON geo.estado_padronizado = loc.estado
    AND geo.cidade_padronizada = loc.cidade


WHERE geo.CEP_PREFIXO IS NOT NULL


GROUP BY 
    geo.CEP_PREFIXO,
    loc.localidade_id
    
ORDER BY 
    geo.CEP_PREFIXO;
