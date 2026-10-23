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
