-- =====================================================
-- REVISÃO 1 - Aulas 01 e 02
-- CREATE TABLE, DEFAULT, INSERT, SELECT, WHERE/IN, ORDER BY, UPDATE, DELETE
-- Schema: revisao01
-- =====================================================

-- Exercício 1 - Criar revisao01.titulo (contas a pagar)
--   id_titulo (SERIAL, PK) | fornecedor VARCHAR(80) obrigatório
--   valor NUMERIC(10,2) obrigatório | vencimento DATE obrigatório
--   pago BOOLEAN obrigatório, padrão FALSE
--   + pergunta (pendência da Aula 01, ex. 3c): se o INSERT não informar "pago",
--     que valor o banco grava? Por quê?
-- Status: FEITO (29/10), na 3ª tentativa (conferido no Supabase)
--   1ª: fornecedor VARCHAR(100) e valor/vencimento sem NOT NULL
--   2ª: NOT NULL corrigido, mas fornecedor ainda VARCHAR(100)
--   -> tabela vazia: corrigida com DROP TABLE + CREATE TABLE de novo
CREATE SCHEMA revisao01;

CREATE TABLE revisao01.titulo (
  id_titulo   SERIAL PRIMARY KEY,
  fornecedor  VARCHAR(80)   NOT NULL,
  valor       NUMERIC(10,2) NOT NULL,
  vencimento  DATE          NOT NULL,
  pago        BOOLEAN       NOT NULL DEFAULT FALSE
);
-- Resposta do Mateus: "já vem como default que não foi pago" -> CERTO.
-- Forma técnica: grava FALSE por causa do DEFAULT FALSE, que é usado quando a
-- coluna NÃO aparece no INSERT (escrever NULL não ativa o DEFAULT).


-- Exercício 2 - Inserir os títulos (dados no formato brasileiro -> converter)
--   Energia Paulista     | 1.250,80 | 10/11/2026 | (não informar)
--   Águas da Cidade      |   380,15 | 05/11/2026 | sim
--   Distribuidora MedSul | 4.900,00 | 20/11/2026 | (não informar)
--   Energia Paulista     | 1.180,40 | 10/10/2026 | sim
--   Papelaria Central    |   215,90 | 28/10/2026 | (não informar)
--   Distribuidora MedSul | 4.900,00 | 20/11/2026 | (não informar)  <- duplicidade proposital
-- Status: FEITO (29/10) - 6 títulos, valores e datas todos certos.
--   Obs.: gravado "Distribuidora Medsul" (s minúsculo). Nos filtros, usar
--   exatamente assim: texto entre aspas diferencia maiúscula de minúscula.
-- ids gerados: 1 Energia 10/11 | 2 Medsul | 3 Papelaria | 4 Medsul (duplicada)
--              5 Águas (pago) | 6 Energia 10/10 (pago)
INSERT INTO revisao01.titulo (fornecedor, valor, vencimento) VALUES
  ('Energia Paulista',     1250.80, '2026-11-10'),
  ('Distribuidora Medsul', 4900.00, '2026-11-20'),
  ('Papelaria Central',     215.90, '2026-10-28'),
  ('Distribuidora Medsul', 4900.00, '2026-11-20');

INSERT INTO revisao01.titulo (fornecedor, valor, vencimento, pago) VALUES
  ('Águas da Cidade',   380.15, '2026-11-05', TRUE),
  ('Energia Paulista', 1180.40, '2026-10-10', TRUE);


-- Exercício 3 - Consultas
--   a) fornecedor, valor e vencimento dos títulos NÃO pagos, do vencimento
--      mais antigo para o mais novo          (esperado: 4 linhas)
--   b) fornecedor e valor dos títulos da Energia Paulista ou da Distribuidora
--      MedSul (usar IN) com valor acima de 1000, do maior para o menor valor
--                                            (esperado: 4 linhas)
-- Status: FEITO (02/11)
-- Tentativas na a): "where pago = 'false' desc" (DESC solto, sem ORDER BY, e
--   direção invertida) -> "order by asc" (faltou a coluna de novo).
-- Tentativa na b): dois WHERE no mesmo comando (o 2º deve ser AND);
--   parênteses sobrando na lista do IN; faltou o ORDER BY.
-- a) 4 linhas: Papelaria 28/10, Energia 10/11, Medsul 20/11, Medsul 20/11
SELECT fornecedor, valor, vencimento FROM revisao01.titulo
WHERE pago = FALSE
ORDER BY vencimento;

-- b) 4 linhas: Medsul 4900, Medsul 4900, Energia 1250.80, Energia 1180.40
SELECT fornecedor, valor FROM revisao01.titulo
WHERE fornecedor IN ('Energia Paulista', 'Distribuidora Medsul')
  AND valor > 1000
ORDER BY valor DESC;


-- Exercício 4 - Ajustes (sempre SELECT de conferência antes)
--   a) o título da Energia Paulista de 10/11/2026 foi pago -> marcar como pago
--   b) excluir a duplicidade da Distribuidora MedSul (apagar só UMA linha)
--   c) Papelaria Central foi digitada errado: o certo é 251,90 (erro de transposição)
--   Resultado final esperado: 5 títulos
-- Status: FEITO (02/11) - conferido no Supabase, de primeira, 5 títulos certos
--   e linhas não alvo intactas.
UPDATE revisao01.titulo SET pago = TRUE WHERE id_titulo = 1;
DELETE FROM revisao01.titulo WHERE id_titulo = 4;   -- só a chave primária diferencia
UPDATE revisao01.titulo SET valor = 251.90 WHERE id_titulo = 3;
-- Lição: filtrar só por fornecedor = 'Energia Paulista' alteraria 2 linhas;
-- na duplicidade, só o id_titulo diferencia uma linha da outra.


-- Exercício 5 - Caça aos erros
--   a) (pendência da Aula 01, ex. 4) os 2 erros que faltam no CREATE TABLE:
--      CREATE TABLE aula01.receita (
--        id_receita  SERIAL PRIMARY KEY
--        descricao   VARCHAR(100) NOT NULL,
--        valor       NUMERIC(10,2),
--        data_receb  DATE,
--      );
--      -> corrigir e criar aula01.receita
--   b) 3 erros nesta consulta (um deles NÃO mostra mensagem de erro!):
--      SELECT fornecedor valor FROM revisao01.titulo
--      WHERE fornecedor = 'Energia Paulista' OR 'Águas da Cidade'
--      ORDER BY DESC;
-- Status: FEITO (02/11)
-- a) aula01.receita criada (conferida no Supabase):
CREATE TABLE aula01.receita (
  id_receita  SERIAL PRIMARY KEY,          -- faltava a vírgula
  descricao   VARCHAR(100) NOT NULL,
  valor       NUMERIC(10,2),
  data_receb  DATE                         -- vírgula sobrando na última coluna
);
-- b) Os 3 erros (o Mateus achou os 3; o 3º com uma dica):
--   1. OR com o lado direito incompleto -> usar IN (...) ou repetir a coluna
--   2. ORDER BY sem a coluna -> ORDER BY valor DESC
--   3. "fornecedor valor" sem vírgula -> NÃO dá erro: "valor" vira APELIDO
--      (alias) da coluna fornecedor. Resultado: 1 coluna só, chamada "valor",
--      com os nomes dos fornecedores dentro. Erro silencioso!
SELECT fornecedor, valor FROM revisao01.titulo
WHERE fornecedor IN ('Energia Paulista', 'Águas da Cidade')
ORDER BY valor DESC;
