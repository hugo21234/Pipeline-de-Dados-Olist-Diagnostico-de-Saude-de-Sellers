-- ============================================================
-- 07 · Auditoria — Verificação de constraints do data_mart
-- ============================================================
-- Retorna todas as PRIMARY KEY e FOREIGN KEY registradas no schema
-- Executar após rodar os scripts 04 → 06 para validar integridade referencial
-- ============================================================

SELECT
    table_name,
    constraint_name,
    constraint_type
FROM system.information_schema.table_constraints
WHERE table_schema  = 'data_mart'
  AND table_catalog = 'seller_ops_mart'
ORDER BY table_name, constraint_type;
