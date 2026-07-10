-- =====================================================
-- SILVER: OLIST_AVALIACAO
-- =====================================================
-- Fonte : seller_ops_mart.bronze.olist_order_reviews_dataset
-- Grão  : 1 linha por avaliação única (avaliacao_id / review_id)
-- PK lógica: avaliacao_id  |  FK: pedido_id -> silver.Olist_orders
--
-- Transformação:
-- 1. Filtra linhas corrompidas da bronze (import trouxe valores
--    fora do formato de hash MD5 esperado em order_id/review_id,
--    e notas fora do range 1-5).
-- 2. review_id É a chave de negócio da avaliação (não o par
--    review_id+order_id) — order_id é FK, não parte da PK.
--    Ver decisão registrada: avaliação é entidade própria,
--    associada a um pedido, não "avaliação por pedido".
-- 3. A bronze ainda contém `review_id` duplicado (2-3 linhas por
--    id, provavelmente reenvio/atualização da mesma avaliação
--    na fonte). ROW_NUMBER() particiona por avaliacao_id e
--    escolhe 1 linha por grupo, com esta ordem de prioridade:
--      a) comentário não nulo vem antes de comentário nulo
--      b) entre iguais, a avaliação mais recente (data_criacao)
--    Isso concentra a decisão de "qual versão vale" em uma regra
--    explícita, em vez de ANY_VALUE() (que pegaria uma linha
--    arbitrária do grupo sem critério).
-- =====================================================

CREATE OR REPLACE TABLE seller_ops_mart.silver.olist_avaliacao AS
WITH avaliacao_filtrada AS (
    SELECT
        review_id               AS avaliacao_id,
        order_id                AS pedido_id,
        review_score            AS nota,
        review_comment_title    AS titulo,
        review_comment_message  AS comentario,
        review_answer_timestamp AS data_resposta,
        review_creation_date    AS data_criacao
    FROM seller_ops_mart.bronze.olist_order_reviews_dataset
    WHERE
        order_id  RLIKE '^[0-9a-f]{32}$'
        AND review_id RLIKE '^[0-9a-f]{32}$'
        AND review_score BETWEEN 1 AND 5
        AND LENGTH(order_id) = 32
        AND LENGTH(review_id) = 32
),
avaliacao_ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY avaliacao_id
            ORDER BY
                CASE WHEN comentario IS NOT NULL THEN 0 ELSE 1 END,
                data_criacao DESC
        ) AS rn
    FROM avaliacao_filtrada
)
SELECT
    avaliacao_id,
    pedido_id,
    nota,
    titulo,
    comentario,
    data_resposta,
    data_criacao
FROM avaliacao_ranked
WHERE rn = 1;
