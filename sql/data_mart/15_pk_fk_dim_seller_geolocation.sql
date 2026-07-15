-- Primeiro: adicionar PRIMARY KEY em dim_seller_geolocation.seller_geolocation_id
ALTER TABLE seller_ops_mart.data_mart.dim_seller_geolocation
ADD CONSTRAINT pk_seller_geolocation PRIMARY KEY (seller_geolocation_id);


-- Segundo: adicionar NOT NULL em dim_seller.geolocation_id
ALTER TABLE seller_ops_mart.data_mart.dim_seller
ALTER COLUMN geolocation_id SET NOT NULL;


-- Terceiro: criar a Foreign Key (relacionamento correto via geolocation_id)
ALTER TABLE seller_ops_mart.data_mart.dim_seller
ADD CONSTRAINT fk_dim_seller_geolocation
FOREIGN KEY (geolocation_id) REFERENCES seller_ops_mart.data_mart.dim_seller_geolocation(seller_geolocation_id);
