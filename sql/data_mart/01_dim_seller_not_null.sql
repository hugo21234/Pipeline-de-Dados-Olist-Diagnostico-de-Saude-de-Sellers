-- Segundo: adicionar NOT NULL em dim_seller.CEP_PREFIXO
ALTER TABLE dim_seller
ALTER COLUMN CEP_PREFIXO SET NOT NULL;
