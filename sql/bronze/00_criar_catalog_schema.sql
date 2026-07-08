-- =====================================================
-- CRIAÇÃO DO CATALOG E DO SCHEMA BRONZE
-- =====================================================
-- Este arquivo cria a "casa" onde todo o domínio de
-- Seller Operations vai morar dentro do Unity Catalog.
--
-- Catalog  = fronteira do domínio (Seller Ops).
-- Schema   = camada dentro do domínio (bronze = dado cru).
-- =====================================================

-- Catalog do domínio de Seller Operations.
-- Aqui vivem todas as camadas (bronze, silver, mart) deste projeto.
CREATE CATALOG IF NOT EXISTS seller_ops_mart
COMMENT 'Catalog para o data mart de operações de sellers (Seller Ops)';

-- Schema bronze: camada de dados crus, uma tabela por arquivo de origem,
-- sem transformação, sem join, sem agregação. É o espelho fiel do CSV.
CREATE SCHEMA IF NOT EXISTS seller_ops_mart.bronze
COMMENT 'Camada bronze - dados crus da plataforma de e-commerce Olist (um-para-um com cada CSV de origem)';
