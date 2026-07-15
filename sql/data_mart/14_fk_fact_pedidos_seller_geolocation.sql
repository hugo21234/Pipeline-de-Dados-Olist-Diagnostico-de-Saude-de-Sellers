-- ========================================
-- ADICIONAR FK PARA SELLER_GEOLOCATION NA FACT_PEDIDOS
-- ========================================
-- Conecta fact_pedidos à nova estrutura normalizada de geolocalizacao
-- seller_location_id -> dim_seller_geolocation.seller_geolocation_id


-- PASSO 1: Dropar a constraint antiga (se existir)
ALTER TABLE seller_ops_mart.data_mart.fact_pedidos
DROP CONSTRAINT IF EXISTS fk_fact_pedidos_seller_location;


-- PASSO 2: Adicionar a nova FK para dim_seller_geolocation
ALTER TABLE seller_ops_mart.data_mart.fact_pedidos
ADD CONSTRAINT fk_fact_pedidos_seller_location
FOREIGN KEY (seller_location_id) 
REFERENCES seller_ops_mart.data_mart.dim_seller_geolocation(seller_geolocation_id);


-- Verificar constraints criadas
DESCRIBE EXTENDED seller_ops_mart.data_mart.fact_pedidos;
