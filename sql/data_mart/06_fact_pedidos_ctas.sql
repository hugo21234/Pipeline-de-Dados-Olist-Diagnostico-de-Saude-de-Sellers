CREATE OR REPLACE TABLE seller_ops_mart.data_mart.FACT_PEDIDOS AS
SELECT 
    -- Chaves primárias e estrangeiras
    i.Pedido_id AS order_id,
    i.Vendedor_id AS seller_id,
    i.Produto_id AS product_id,
    o.id_cliente AS customer_id,
    DATE(o.Horario_da_Compra) AS time_id,
    s.prefix_cep_norm AS seller_location_id,
    p.id_categoria AS product_category_id,
    
    -- Atributos do pedido
    o.Status_Pedido AS order_status,
    o.Horario_da_Compra AS order_purchase_timestamp,
    o.Entregue_Pelo_Cliente AS order_delivered_customer_date,
    ob.order_estimated_delivery_date AS order_estimated_delivery_date,
    
    -- Métricas calculadas
    DATEDIFF(DAY, ob.order_estimated_delivery_date, o.Entregue_Pelo_Cliente) AS dias_atraso,
    CASE 
        WHEN DATEDIFF(DAY, ob.order_estimated_delivery_date, o.Entregue_Pelo_Cliente) > 0 
        THEN TRUE 
        ELSE FALSE 
    END AS atrasou,
    ROUND(i.Preco + i.Frete, 2) AS valor_pedido
    
FROM seller_ops_mart.silver.itens_pedidos AS i
INNER JOIN seller_ops_mart.silver.olist_orders AS o
    ON i.Pedido_id = o.id_pedido
LEFT JOIN seller_ops_mart.bronze.olist_orders_dataset AS ob
    ON o.id_pedido = ob.order_id
LEFT JOIN seller_ops_mart.data_mart.dim_product AS p
    ON i.Produto_id = p.produto_id
LEFT JOIN seller_ops_mart.data_mart.dim_seller AS s
    ON i.Vendedor_id = s.vendedor_id
WHERE o.Status_Pedido = 'delivered';
