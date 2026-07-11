-- ============================================================
-- 05 · dim_time — Dimensão de Tempo (CTAS + NOT NULL + PK)
-- ============================================================

-- 1) Cria (ou recria) a tabela a partir das datas únicas dos pedidos
CREATE OR REPLACE TABLE seller_ops_mart.data_mart.dim_time AS
WITH datas_unicas AS (
    -- Extrai todas as datas únicas com compra registrada
    SELECT DISTINCT DATE(Horario_da_Compra) AS data
    FROM seller_ops_mart.silver.olist_orders
    WHERE Horario_da_Compra IS NOT NULL
)
SELECT
    data                                            AS data_id,         -- PK
    YEAR(data)                                      AS ano,
    MONTH(data)                                     AS mes,
    DATE_FORMAT(data, 'MMMM')                       AS nome_mes,
    QUARTER(data)                                   AS trimestre,
    DAY(data)                                       AS dia,
    DATE_FORMAT(data, 'EEEE')                       AS dia_da_semana,
    DAYOFWEEK(data)                                 AS numero_dia_semana,
    WEEKOFYEAR(data)                                AS semana_do_ano,
    DAYOFYEAR(data)                                 AS dia_do_ano,
    CASE
        WHEN DAYOFWEEK(data) IN (1, 7) THEN TRUE
        ELSE FALSE
    END                                             AS eh_fim_de_semana,
    DATE_FORMAT(data, 'yyyy-MM')                    AS ano_mes,
    CONCAT('Q', QUARTER(data), '-', YEAR(data))     AS trimestre_ano
FROM datas_unicas
ORDER BY data;

-- 2) Garante NOT NULL na PK antes de criar a constraint
ALTER TABLE seller_ops_mart.data_mart.dim_time
    ALTER COLUMN data_id SET NOT NULL;

-- 3) Define a chave primária
ALTER TABLE seller_ops_mart.data_mart.dim_time
    ADD CONSTRAINT pk_dim_time PRIMARY KEY (data_id);
