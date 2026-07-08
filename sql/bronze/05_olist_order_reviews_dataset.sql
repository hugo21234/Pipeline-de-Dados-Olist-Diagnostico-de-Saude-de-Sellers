-- =====================================================
-- BRONZE: olist_order_reviews_dataset
-- =====================================================
-- Grão: 1 linha por review associada a um pedido
-- (um pedido pode, em teoria, ter mais de uma review).
-- PK lógica: review_id.
-- Origem: olist_order_reviews_dataset.csv.
--
-- Esta tabela alimenta diretamente o fato F_SELLER_REVIEWS
-- descrito no README (grão: 1 linha por review ligada a
-- pedido e seller).
-- =====================================================

CREATE TABLE IF NOT EXISTS seller_ops_mart.bronze.olist_order_reviews_dataset (
  review_id                STRING,     -- identificador único da review
  order_id                 STRING,     -- FK lógica para olist_orders_dataset
  review_score             BIGINT,     -- nota da review (regra de negócio: deve estar entre 1 e 5)
  review_comment_title     STRING,     -- título do comentário (pode ser nulo)
  review_comment_message   STRING,     -- mensagem do comentário (pode ser nulo)
  review_creation_date     TIMESTAMP,  -- data em que a review foi criada
  review_answer_timestamp  TIMESTAMP   -- data em que a review foi respondida pelo cliente
)
USING DELTA
COMMENT 'Reviews de pedidos cruas do dataset Olist - camada bronze (insumo direto de F_SELLER_REVIEWS)';
