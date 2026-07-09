-- =====================================================
-- SILVER: OLIST_CLIENTE
-- =====================================================
-- Fonte : seller_ops_mart.bronze.olist_customers_dataset
-- Grão  : 1 linha por CLIENTE ÚNICO (customer_unique_id)
--
-- Transformação: a bronze tem grão de "customer_id" (1 por
-- pedido, já que o Olist gera um customer_id novo a cada
-- compra do mesmo cliente). Aqui o grão é desnormalizado
-- para customer_unique_id via GROUP BY, usando ANY_VALUE
-- nas colunas descritivas (cep, cidade, estado) porque não
-- há garantia de que sejam idênticas entre os customer_id
-- de um mesmo cliente — ANY_VALUE assume a primeira ocorrência
-- como representativa, o que é aceitável para dimensão de
-- cliente, mas não seria para métricas financeiras.
-- =====================================================

CREATE OR REPLACE TABLE seller_ops_mart.silver.OLIST_Cliente AS
SELECT
    ANY_VALUE(customer_id)            AS id_cliente,
    customer_unique_id                AS id_cliente_unico,
    ANY_VALUE(customer_zip_code_prefix) AS cep,
    ANY_VALUE(customer_city)          AS cidade,
    ANY_VALUE(customer_state)         AS estado
FROM seller_ops_mart.bronze.olist_customers_dataset
GROUP BY customer_unique_id;
