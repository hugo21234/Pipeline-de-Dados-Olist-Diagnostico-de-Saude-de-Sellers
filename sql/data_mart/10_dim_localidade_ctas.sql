-- ========================================
-- DIMENSÃO: LOCALIDADE (CIDADE + ESTADO)
-- ========================================
-- Tabela mestre de localidades únicas
-- Cada combinação estado + cidade recebe um UUID único
-- Será referenciada pela dim_seller_geolocation


USE CATALOG seller_ops_mart;


CREATE OR REPLACE TABLE data_mart.dim_localidade AS


SELECT 
    uuid() AS localidade_id,
    estado_padronizado AS estado,
    cidade_padronizada AS cidade
    
FROM silver.geolocalizacao


WHERE estado_padronizado IS NOT NULL 
  AND cidade_padronizada IS NOT NULL


GROUP BY 
    estado_padronizado,
    cidade_padronizada
    
ORDER BY 
    estado_padronizado,
    cidade_padronizada;
