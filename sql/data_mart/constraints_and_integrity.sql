-- ========================================
-- PASSO 1: CRIAR REGISTROS PADRÃO NAS DIMENSÕES
-- ========================================


-- Inserir registro UNKNOWN em dim_seller se não existir
MERGE INTO seller_ops_mart.data_mart.dim_seller AS target
USING (SELECT 'UNKNOWN' AS vendedor_id, 'UNKNOWN' AS prefix_cep_norm) AS source
ON target.vendedor_id = source.vendedor_id
WHEN NOT MATCHED THEN INSERT (vendedor_id, prefix_cep_norm) VALUES (source.vendedor_id, source.prefix_cep_norm);


-- Inserir registro UNKNOWN em dim_product se não existir
MERGE INTO seller_ops_mart.data_mart.dim_product AS target
USING (SELECT 'UNKNOWN' AS produto_id, 'UNKNOWN' AS id_categoria) AS source
ON target.produto_id = source.produto_id
WHEN NOT MATCHED THEN INSERT (produto_id, id_categoria) VALUES (source.produto_id, source.id_categoria);


-- Inserir registro UNKNOWN em sub_dim_categoria_de_produto se não existir
MERGE INTO seller_ops_mart.data_mart.sub_dim_categoria_de_produto AS target
USING (SELECT 'UNKNOWN' AS id_categoria, 'Unknown' AS nome_da_categoria_do_produto, 'Unknown' AS nome_ingles_da_categoria_do_produto) AS source
ON target.id_categoria = source.id_categoria
WHEN NOT MATCHED THEN INSERT (id_categoria, nome_da_categoria_do_produto, nome_ingles_da_categoria_do_produto) 
VALUES (source.id_categoria, source.nome_da_categoria_do_produto, source.nome_ingles_da_categoria_do_produto);


-- Inserir data padrão em dim_time se não existir
MERGE INTO seller_ops_mart.data_mart.dim_time AS target
USING (SELECT DATE '1900-01-01' AS data_id) AS source
ON target.data_id = source.data_id
WHEN NOT MATCHED THEN INSERT (data_id, ano, mes, dia) VALUES (source.data_id, 1900, 1, 1);


-- ========================================
-- PASSO 2: TRATAR VALORES NULL EM FACT_PEDIDOS
-- ========================================


UPDATE seller_ops_mart.data_mart.fact_pedidos
SET product_category_id = 'UNKNOWN'
WHERE product_category_id IS NULL;


UPDATE seller_ops_mart.data_mart.fact_pedidos
SET seller_location_id = 'UNKNOWN'
WHERE seller_location_id IS NULL;


UPDATE seller_ops_mart.data_mart.fact_pedidos
SET time_id = DATE '1900-01-01'
WHERE time_id IS NULL;


UPDATE seller_ops_mart.data_mart.fact_pedidos
SET seller_id = 'UNKNOWN'
WHERE seller_id IS NULL;


UPDATE seller_ops_mart.data_mart.fact_pedidos
SET product_id = 'UNKNOWN'
WHERE product_id IS NULL;


-- ========================================
-- PASSO 3: ALTERAR COLUNAS PARA NOT NULL - FACT_PEDIDOS
-- ========================================


ALTER TABLE seller_ops_mart.data_mart.fact_pedidos ALTER COLUMN order_id SET NOT NULL;
ALTER TABLE seller_ops_mart.data_mart.fact_pedidos ALTER COLUMN seller_id SET NOT NULL;
ALTER TABLE seller_ops_mart.data_mart.fact_pedidos ALTER COLUMN product_id SET NOT NULL;
ALTER TABLE seller_ops_mart.data_mart.fact_pedidos ALTER COLUMN time_id SET NOT NULL;
ALTER TABLE seller_ops_mart.data_mart.fact_pedidos ALTER COLUMN product_category_id SET NOT NULL;


-- ========================================
-- PASSO 4: PREPARAR DIMENSÕES PARA PRIMARY KEYS
-- ========================================


-- Tratar NULLs e definir NOT NULL nas PKs das dimensões
UPDATE seller_ops_mart.data_mart.dim_seller SET vendedor_id = 'UNKNOWN_' || uuid() WHERE vendedor_id IS NULL;
ALTER TABLE seller_ops_mart.data_mart.dim_seller ALTER COLUMN vendedor_id SET NOT NULL;


UPDATE seller_ops_mart.data_mart.dim_product SET produto_id = 'UNKNOWN_' || uuid() WHERE produto_id IS NULL;
ALTER TABLE seller_ops_mart.data_mart.dim_product ALTER COLUMN produto_id SET NOT NULL;


UPDATE seller_ops_mart.data_mart.sub_dim_categoria_de_produto SET id_categoria = 'UNKNOWN_' || uuid() WHERE id_categoria IS NULL;
ALTER TABLE seller_ops_mart.data_mart.sub_dim_categoria_de_produto ALTER COLUMN id_categoria SET NOT NULL;


-- ========================================
-- PASSO 5: PRIMARY KEYS DAS DIMENSÕES
-- ========================================


ALTER TABLE seller_ops_mart.data_mart.dim_seller ADD CONSTRAINT pk_dim_seller PRIMARY KEY (vendedor_id);
ALTER TABLE seller_ops_mart.data_mart.dim_product ADD CONSTRAINT pk_dim_product PRIMARY KEY (produto_id);
ALTER TABLE seller_ops_mart.data_mart.sub_dim_categoria_de_produto ADD CONSTRAINT pk_sub_dim_categoria PRIMARY KEY (id_categoria);


-- ========================================
-- PASSO 6: PRIMARY KEY - FACT_PEDIDOS
-- ========================================


ALTER TABLE seller_ops_mart.data_mart.fact_pedidos ADD CONSTRAINT pk_fact_pedidos PRIMARY KEY (order_id);


-- ========================================
-- PASSO 7: FOREIGN KEYS - FACT_PEDIDOS
-- ========================================


ALTER TABLE seller_ops_mart.data_mart.fact_pedidos
ADD CONSTRAINT fk_fact_pedidos_seller 
  FOREIGN KEY (seller_id) REFERENCES seller_ops_mart.data_mart.dim_seller(vendedor_id);


ALTER TABLE seller_ops_mart.data_mart.fact_pedidos
ADD CONSTRAINT fk_fact_pedidos_product 
  FOREIGN KEY (product_id) REFERENCES seller_ops_mart.data_mart.dim_product(produto_id);


ALTER TABLE seller_ops_mart.data_mart.fact_pedidos
ADD CONSTRAINT fk_fact_pedidos_time 
  FOREIGN KEY (time_id) REFERENCES seller_ops_mart.data_mart.dim_time(data_id);


ALTER TABLE seller_ops_mart.data_mart.fact_pedidos
ADD CONSTRAINT fk_fact_pedidos_product_category 
  FOREIGN KEY (product_category_id) REFERENCES seller_ops_mart.data_mart.sub_dim_categoria_de_produto(id_categoria);


-- ========================================
-- PASSO 8: TRATAR VALORES NULL - FACT_REVIEWS
-- ========================================


UPDATE seller_ops_mart.data_mart.fact_reviews
SET time_id = '19000101'
WHERE time_id IS NULL;


UPDATE seller_ops_mart.data_mart.fact_reviews
SET seller_id = 'UNKNOWN'
WHERE seller_id IS NULL;


-- ========================================
-- PASSO 9: ALTERAR COLUNAS PARA NOT NULL - FACT_REVIEWS
-- ========================================


ALTER TABLE seller_ops_mart.data_mart.fact_reviews ALTER COLUMN review_id SET NOT NULL;
ALTER TABLE seller_ops_mart.data_mart.fact_reviews ALTER COLUMN order_id SET NOT NULL;
ALTER TABLE seller_ops_mart.data_mart.fact_reviews ALTER COLUMN time_id SET NOT NULL;
ALTER TABLE seller_ops_mart.data_mart.fact_reviews ALTER COLUMN seller_id SET NOT NULL;


-- ========================================
-- PASSO 10: PRIMARY KEY - FACT_REVIEWS
-- ========================================


ALTER TABLE seller_ops_mart.data_mart.fact_reviews ADD CONSTRAINT pk_fact_reviews PRIMARY KEY (review_id);


-- ========================================
-- PASSO 11: FOREIGN KEYS - FACT_REVIEWS
-- ========================================


ALTER TABLE seller_ops_mart.data_mart.fact_reviews
ADD CONSTRAINT fk_fact_reviews_order 
  FOREIGN KEY (order_id) REFERENCES seller_ops_mart.data_mart.fact_pedidos(order_id);


ALTER TABLE seller_ops_mart.data_mart.fact_reviews
ADD CONSTRAINT fk_fact_reviews_seller 
  FOREIGN KEY (seller_id) REFERENCES seller_ops_mart.data_mart.dim_seller(vendedor_id);


-- ========================================
-- PASSO 12: CONVERTER TIME_ID E ADICIONAR FK
-- ========================================


-- Habilitar Column Mapping para permitir DROP COLUMN
ALTER TABLE seller_ops_mart.data_mart.fact_reviews SET TBLPROPERTIES ('delta.columnMapping.mode' = 'name');


-- Criar nova coluna time_id_date
ALTER TABLE seller_ops_mart.data_mart.fact_reviews ADD COLUMN time_id_date DATE;


-- Migrar dados convertendo de STRING para DATE
UPDATE seller_ops_mart.data_mart.fact_reviews
SET time_id_date = to_date(time_id, 'yyyyMMdd');


-- Definir NOT NULL
ALTER TABLE seller_ops_mart.data_mart.fact_reviews ALTER COLUMN time_id_date SET NOT NULL;


-- Dropar coluna antiga
ALTER TABLE seller_ops_mart.data_mart.fact_reviews DROP COLUMN time_id;


-- Renomear nova coluna
ALTER TABLE seller_ops_mart.data_mart.fact_reviews RENAME COLUMN time_id_date TO time_id;


-- Adicionar FK de time_id para dim_time
ALTER TABLE seller_ops_mart.data_mart.fact_reviews
ADD CONSTRAINT fk_fact_reviews_time 
  FOREIGN KEY (time_id) REFERENCES seller_ops_mart.data_mart.dim_time(data_id);
