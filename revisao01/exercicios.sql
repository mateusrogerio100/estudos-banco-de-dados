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
-- (resolução do Mateus)


-- Exercício 2 - Inserir os títulos (dados no formato brasileiro -> converter)
--   Energia Paulista     | 1.250,80 | 10/11/2026 | (não informar)
--   Águas da Cidade      |   380,15 | 05/11/2026 | sim
--   Distribuidora MedSul | 4.900,00 | 20/11/2026 | (não informar)
--   Energia Paulista     | 1.180,40 | 10/10/2026 | sim
--   Papelaria Central    |   215,90 | 28/10/2026 | (não informar)
--   Distribuidora MedSul | 4.900,00 | 20/11/2026 | (não informar)  <- duplicidade proposital
-- (resolução do Mateus)


-- Exercício 3 - Consultas
--   a) fornecedor, valor e vencimento dos títulos NÃO pagos, do vencimento
--      mais antigo para o mais novo          (esperado: 4 linhas)
--   b) fornecedor e valor dos títulos da Energia Paulista ou da Distribuidora
--      MedSul (usar IN) com valor acima de 1000, do maior para o menor valor
--                                            (esperado: 4 linhas)
-- (resolução do Mateus)


-- Exercício 4 - Ajustes (sempre SELECT de conferência antes)
--   a) o título da Energia Paulista de 10/11/2026 foi pago -> marcar como pago
--   b) excluir a duplicidade da Distribuidora MedSul (apagar só UMA linha)
--   c) Papelaria Central foi digitada errado: o certo é 251,90 (erro de transposição)
--   Resultado final esperado: 5 títulos
-- (resolução do Mateus)


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
-- (resolução do Mateus)
