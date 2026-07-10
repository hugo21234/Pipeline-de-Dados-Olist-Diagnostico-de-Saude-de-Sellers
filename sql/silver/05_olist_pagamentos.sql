-- =====================================================
-- SILVER: OLIST_PAGAMENTOS
-- =====================================================
-- Fonte : seller_ops_mart.bronze.olist_order_payments_dataset
-- Grão  : 1 linha por (pedido, sequencial de pagamento)
--
-- Transformação: apenas renomeação de colunas para PT-BR.
-- Sem agregação, sem join — o grão da bronze é preservado.
-- Um pedido pode ter múltiplas linhas quando o pagamento é
-- feito em mais de uma forma (ex.: voucher + cartão), por
-- isso a chave de negócio é o par (pedido_id, pagamento_sequencial),
-- não pedido_id isoladamente.
-- =====================================================

CREATE OR REPLACE TABLE seller_ops_mart.silver.olist_pagamentos AS
SELECT
    order_id            AS pedido_id,
    payment_sequential  AS pagamento_sequencial,
    payment_type        AS tipo_pagamento,
    payment_installments AS parcelas,
    payment_value        AS valor
FROM seller_ops_mart.bronze.olist_order_payments_dataset;
