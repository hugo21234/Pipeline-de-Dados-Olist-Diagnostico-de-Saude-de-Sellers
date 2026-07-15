-- ========================================
-- VIEW: PERFORMANCE NEGATIVA DE SELLERS
-- ========================================
-- Combina pedidos atrasados + reviews com notas ruins
-- Foco em identificar sellers com problemas de entrega e avaliação


CREATE OR REPLACE VIEW seller_ops_mart.data_mart.vw_performance_negativa_sellers AS


SELECT 
    fp.order_id,
    fp.seller_id,
    fp.atrasou AS pedido_atrasado,
    fp.dias_atraso,
    fr.review_score AS nota_review,
    
    -- Classificação de problema
    CASE 
        WHEN fp.atrasou = TRUE AND fr.review_score <= 2 THEN 'CRÍTICO: Atraso + Nota Ruim'
        WHEN fp.atrasou = TRUE THEN 'Pedido Atrasado'
        WHEN fr.review_score <= 2 THEN 'Nota Ruim'
        ELSE 'OK'
    END AS tipo_problema
    
FROM seller_ops_mart.data_mart.fact_pedidos fp


INNER JOIN seller_ops_mart.data_mart.fact_reviews fr
    ON fp.order_id = fr.order_id
    AND fp.seller_id = fr.seller_id
    
WHERE fp.order_status = 'delivered'
    AND (fp.atrasou = TRUE OR fr.review_score <= 2)
    
ORDER BY 
    CASE 
        WHEN fp.atrasou = TRUE AND fr.review_score <= 2 THEN 1
        WHEN fp.atrasou = TRUE THEN 2
        WHEN fr.review_score <= 2 THEN 3
    END,
    fp.dias_atraso DESC;
