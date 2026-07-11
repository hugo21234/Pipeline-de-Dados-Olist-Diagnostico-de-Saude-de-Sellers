-- Terceiro: criar a Foreign Key (agora ambas são STRING)
ALTER TABLE dim_seller
ADD CONSTRAINT fk_dim_seller_geolocation
FOREIGN KEY (CEP_PREFIXO) 
    REFERENCES seller_ops_mart.data_mart.sellers_geolacation(CEP_PREFIXO);
