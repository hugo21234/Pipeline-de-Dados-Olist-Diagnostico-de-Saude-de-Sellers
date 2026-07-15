-- VIEW: Análise de Performance de Sellers
-- Combina métricas de atraso na entrega + avaliações dos clientes
-- Quanto MAIOR o índice_performance_ruim, PIOR o seller


CREATE OR REPLACE VIEW seller_ops_mart.data_mart.vw_analise_sellers_performance AS


SELECT 
    fp.seller_id,
    
    -- Métricas de Pedidos
    COUNT(DISTINCT fp.order_id) AS total_pedidos,
    COUNT(DISTINCT CASE WHEN fp.atrasou = TRUE THEN fp.order_id END) AS total_pedidos_atrasados,
    ROUND(COUNT(CASE WHEN fp.atrasou = TRUE THEN 1 END) * 100.0 / COUNT(fp.order_id), 2) AS perc_pedidos_atrasados,
    
    -- Métricas de Atraso
    ROUND(AVG(fp.dias_atraso), 2) AS media_dias_atraso,
    MAX(fp.dias_atraso) AS max_dias_atraso,
    MIN(fp.dias_atraso) AS min_dias_atraso,
    
    -- Métricas de Avaliação
    COUNT(DISTINCT fr.review_id) AS total_avaliacoes,
    ROUND(AVG(fr.review_score), 2) AS media_nota_avaliacao,
    COUNT(CASE WHEN fr.review_score <= 2 THEN 1 END) AS avaliacoes_negativas,
    COUNT(CASE WHEN fr.review_score >= 4 THEN 1 END) AS avaliacoes_positivas,
    
    -- Índice de Performance (quanto MAIOR, PIOR o seller)
    -- Fórmula: (Média Atraso × 0.5) + ((5 - Média Nota) × 2)
    ROUND(
        (AVG(fp.dias_atraso) * 0.5) + ((5 - AVG(fr.review_score)) * 2), 
        2
    ) AS indice_performance_ruim,
    
    -- Métricas Financeiras
    ROUND(SUM(fp.valor_pedido), 2) AS receita_total
    
FROM seller_ops_mart.data_mart.fact_pedidos fp
INNER JOIN seller_ops_mart.data_mart.fact_reviews fr
    ON fp.order_id = fr.order_id
    
WHERE fp.order_status = 'delivered'
    AND fp.dias_atraso IS NOT NULL
    AND fr.review_score IS NOT NULL
    
GROUP BY fp.seller_id
HAVING COUNT(fp.order_id) >= 5  -- Sellers com pelo menos 5 pedidos


ORDER BY indice_performance_ruim DESC;
