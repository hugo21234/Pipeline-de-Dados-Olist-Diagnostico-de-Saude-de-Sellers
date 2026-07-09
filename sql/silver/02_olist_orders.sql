-- =====================================================
-- SILVER: OLIST_ORDERS
-- =====================================================
-- Fonte : seller_ops_mart.bronze.olist_orders_dataset
-- Grão  : 1 linha por pedido (order_id)
-- PK lógica: id_pedido
--
-- Transformação: apenas renomeação de colunas para PT-BR.
-- Sem agregação, sem join — o grão da bronze é preservado.
-- =====================================================

CREATE OR REPLACE TABLE seller_ops_mart.silver.Olist_orders AS
SELECT
    order_id                     AS id_pedido,
    customer_id                  AS id_cliente,
    order_status                 AS Status_Pedido,
    order_purchase_timestamp     AS Horario_da_Compra,
    order_approved_at            AS Pedido_Aprovado,
    order_delivered_carrier_date AS Entregue_Por_Carregador,
    order_delivered_customer_date AS Entregue_Pelo_Cliente
FROM seller_ops_mart.bronze.olist_orders_dataset;
