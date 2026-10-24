-- =====================================================
-- AULA 01 - Exercícios
-- Schema: aula01
-- =====================================================

CREATE SCHEMA IF NOT EXISTS aula01;

-- -----------------------------------------------------
-- Exercício 1 - Criar a tabela de categorias de gastos
-- -----------------------------------------------------
CREATE TABLE aula01.categoria (
  id_categoria  SERIAL PRIMARY KEY,
  nome          VARCHAR(50) NOT NULL,
  despesa_fixa  BOOLEAN
);

-- -----------------------------------------------------
-- Exercício 2a - Inserir 3 categorias
-- -----------------------------------------------------
INSERT INTO aula01.categoria (nome, despesa_fixa) VALUES
  ('Aluguel',  TRUE),
  ('Mercado',  FALSE),
  ('Internet', TRUE);

-- -----------------------------------------------------
-- Exercício 2b - Mostrar só o nome das categorias
-- -----------------------------------------------------
SELECT nome FROM aula01.categoria;

-- =====================================================
-- EXERCÍCIOS DE FIXAÇÃO
-- =====================================================

-- -----------------------------------------------------
-- Exercício 3 - Tabela de despesas (dinheiro, data e DEFAULT)
-- Status: tabela OK / os 3 dados errados foram corrigidos com UPDATE na Aula 02 (24/10)
-- -----------------------------------------------------
CREATE TABLE aula01.despesa (
  id_despesa  SERIAL PRIMARY KEY,
  descricao   VARCHAR(100) NOT NULL,
  valor       NUMERIC(10,2) NOT NULL,
  data_venc   DATE,
  paga        BOOLEAN NOT NULL DEFAULT FALSE
);

-- 3a) Sem a coluna "paga": o banco usa o DEFAULT (FALSE)
INSERT INTO aula01.despesa (descricao, valor, data_venc) VALUES
  ('Conta de luz',   185.40, '2026-11-10'),
  ('Mercado do mês', 892.37, '2026-10-28');

-- Com a coluna "paga" informada
INSERT INTO aula01.despesa (descricao, valor, data_venc, paga) VALUES
  ('Aluguel', 1500.00, '2026-11-05', TRUE);

-- 3b)
SELECT descricao, valor, paga FROM aula01.despesa;

-- 3c) PENDENTE: explicar o que apareceu na coluna "paga" e por quê.

-- O que aprendi:
--  * Data é sempre 'AAAA-MM-DD'. '28-10-2026' dá erro (não existe mês 28).
--  * Data com dia e mês trocados pode NÃO dar erro (ex.: '2026-10-11') -> conferir sempre!
--  * Escrever NULL é informar "vazio": não ativa o DEFAULT e quebra o NOT NULL.
--    Para usar o DEFAULT, a coluna nem aparece no INSERT.
--  * Um INSERT é "tudo ou nada": se uma linha falha, nenhuma é gravada.
--  * O SERIAL não volta atrás após erro: os códigos podem ter "buracos" (começou no 2).
--
-- No banco tinha ficado gravado com erro (CORRIGIDO na Aula 02):
--  * id 2 Conta de luz: data 2026-10-11 -> correto 2026-11-10
--  * id 4 "Alguel": nome -> Aluguel; data 2026-05-11 -> correto 2026-11-05

-- -----------------------------------------------------
-- Exercício 4 - Caça aos erros (código do colega)
-- Status: 2 de 4 erros encontrados
-- -----------------------------------------------------
/*
CREATE TABLE aula01.receita (
  id_receita  SERIAL PRIMARY KEY
  descricao   VARCHAR(100) NOT NULL,
  valor       NUMERIC(10,2),
  data_receb  DATE,
);

INSERT INTO aula01.receita (descricao, valor, data_receb)
VALUES (Salário, 3500,00, '2026-10-05');
*/
-- Erros encontrados:
--  1. Salário sem aspas -> o banco acha que é nome de coluna. Certo: 'Salário'
--  2. 3500,00 com vírgula -> vira dois valores (4 valores p/ 3 colunas). Certo: 3500.00
-- PENDENTE: achar os 2 erros do CREATE TABLE (dica: regra das vírgulas)
