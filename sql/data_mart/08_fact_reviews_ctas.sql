CREATE OR REPLACE TABLE FACT_REVIEWS AS
SELECT 
  a.avaliacao_id AS review_id,
  a.pedido_id AS order_id,
  DATE_FORMAT(COALESCE(a.data_criacao, a.data_resposta), 'yyyyMMdd') AS time_id,
  ip.Vendedor_id AS seller_id,
  a.nota AS review_score,
  a.titulo AS comment_title,
  a.comentario AS message
FROM seller_ops_mart.silver.avalicao a
LEFT JOIN seller_ops_mart.silver.itens_pedidos ip ON a.pedido_id = ip.Pedido_id;
