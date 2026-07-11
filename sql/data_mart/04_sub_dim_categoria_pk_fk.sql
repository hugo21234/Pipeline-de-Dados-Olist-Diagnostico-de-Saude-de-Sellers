-- ============================================================
-- 04 · sub_dim_categoria_de_produto — NOT NULL + PK + FK em dim_product
-- ============================================================

-- 1) Garante que a coluna id_categoria não aceita nulos
ALTER TABLE seller_ops_mart.data_mart.sub_dim_categoria_de_produto
    ALTER COLUMN id_categoria SET NOT NULL;

-- 2) Define a chave primária da sub-dimensão de categoria
ALTER TABLE seller_ops_mart.data_mart.sub_dim_categoria_de_produto
    ADD CONSTRAINT pk_categoria_de_produto
    PRIMARY KEY (id_categoria);

-- 3) Adiciona a FK em dim_product referenciando a sub-dimensão
ALTER TABLE seller_ops_mart.data_mart.dim_product
    ADD CONSTRAINT fk_dim_product_id_categoria
    FOREIGN KEY (id_categoria)
    REFERENCES seller_ops_mart.data_mart.sub_dim_categoria_de_produto (id_categoria);
