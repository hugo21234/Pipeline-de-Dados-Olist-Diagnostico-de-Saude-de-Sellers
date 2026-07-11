-- ============================================================
-- 06 · fact_pedidos — Tabela Fato Central do Data Mart
-- ============================================================
-- Granularidade: 1 linha por item de pedido entregue
-- FKs: dim_seller, dim_product, dim_time, sub_dim_geolocation, sub_dim_categoria
-- Métricas: valor_pedido, dias_atraso, atrasou (booleano)
-- ============================================================

CREATE OR REPLACE TABLE seller_ops_mart.data_mart.fact_pedidos AS
SELECT
    -- Chaves
    i.Pedido_id                                         AS order_id,
    i.Vendedor_id                                       AS seller_id,            -- FK → dim_seller
    i.Produto_id                                        AS product_id,           -- FK → dim_product
    o.id_cliente                                        AS customer_id,
    DATE(o.Horario_da_Compra)                           AS time_id,              -- FK → dim_time
    s.prefix_cep_norm                                   AS seller_location_id,   -- FK → sub_dim_geolocation
    p.id_categoria                                      AS product_category_id,  -- FK → sub_dim_categoria_de_produto

    -- Atributos descritivos
    o.Status_Pedido                                     AS order_status,
    o.Horario_da_Compra                                 AS order_purchase_timestamp,
    o.Entregue_Pelo_Cliente                             AS order_delivered_customer_date,
    ob.order_estimated_delivery_date                    AS order_estimated_delivery_date,

    -- Métricas
    DATEDIFF(
        DAY,
        ob.order_estimated_delivery_date,
        o.Entregue_Pelo_Cliente
    )                                                   AS dias_atraso,

    CASE
        WHEN DATEDIFF(
            DAY,
            ob.order_estimated_delivery_date,
            o.Entregue_Pelo_Cliente
        ) > 0 THEN TRUE
        ELSE FALSE
    END                                                 AS atrasou,

    ROUND(i.Preco + i.Frete, 2)                         AS valor_pedido

FROM seller_ops_mart.silver.itens_pedidos        AS i

INNER JOIN seller_ops_mart.silver.olist_orders   AS o
    ON i.Pedido_id = o.id_pedido

LEFT JOIN seller_ops_mart.bronze.olist_orders_dataset AS ob
    ON o.id_pedido = ob.order_id

LEFT JOIN seller_ops_mart.data_mart.dim_product  AS p
    ON i.Produto_id = p.produto_id

LEFT JOIN seller_ops_mart.data_mart.dim_seller   AS s
    ON i.Vendedor_id = s.vendedor_id

WHERE o.Status_Pedido = 'delivered';
