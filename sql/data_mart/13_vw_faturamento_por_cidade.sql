-- ========================================
-- VIEW: FATURAMENTO POR CIDADE
-- ========================================
-- Agrega faturamento e pedidos por localidade (cidade + estado)
-- Usa a estrutura normalizada de geolocalizacao


CREATE OR REPLACE VIEW seller_ops_mart.data_mart.vw_faturamento_por_cidade AS


SELECT 
    loc.cidade,
    loc.estado,
    
    -- Métricas Financeiras
    ROUND(SUM(fp.valor_pedido), 2) AS faturamento_total,
    ROUND(AVG(fp.valor_pedido), 2) AS ticket_medio,
    
    -- Métricas de Pedidos
    COUNT(DISTINCT fp.order_id) AS total_pedidos,
    COUNT(DISTINCT fp.seller_id) AS total_sellers,
    
    -- Métricas de Categorias
    COUNT(DISTINCT fp.product_category_id) AS total_categorias,
    COUNT(*) AS total_itens
    
FROM seller_ops_mart.data_mart.fact_pedidos fp


INNER JOIN seller_ops_mart.data_mart.dim_seller ds
    ON fp.seller_id = ds.seller_id
    
INNER JOIN seller_ops_mart.data_mart.dim_seller_geolocation sg
    ON ds.geolocation_id = sg.seller_geolocation_id
    
INNER JOIN seller_ops_mart.data_mart.dim_localidade loc
    ON sg.localidade_id = loc.localidade_id
    
WHERE fp.order_status = 'delivered'


GROUP BY 
    loc.cidade,
    loc.estado
    
ORDER BY 
    faturamento_total DESC;
