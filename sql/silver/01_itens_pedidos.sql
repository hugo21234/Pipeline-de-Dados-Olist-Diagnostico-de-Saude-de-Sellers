-- =====================================================
-- SILVER: ITENS_PEDIDOS
-- =====================================================
-- Fonte : seller_ops_mart.bronze.olist_order_items_dataset
-- Grão  : 1 linha por item de pedido (order_id + order_item_id)
-- PK lógica: (Pedido_id, Item_id)
--
-- Transformação: apenas renomeação de colunas para PT-BR.
-- Sem agregação, sem join — o grão da bronze é preservado.
-- =====================================================

CREATE OR REPLACE TABLE seller_ops_mart.silver.Itens_Pedidos AS
SELECT
    order_id          AS Pedido_id,
    order_item_id     AS Item_id,
    product_id        AS Produto_id,
    seller_id         AS Vendedor_id,
    shipping_limit_date AS Data_entrega,
    price             AS Preco,
    freight_value     AS Frete
FROM seller_ops_mart.bronze.olist_order_items_dataset;
