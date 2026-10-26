-- =====================================================
-- AULA 02 - Exercícios
-- WHERE, ORDER BY, UPDATE e DELETE
-- =====================================================

-- -----------------------------------------------------
-- Exercício 1 - Corrigir os dados errados de aula01.despesa (UPDATE)
--   id 2 Conta de luz : data 2026-10-11 -> 2026-11-10
--   id 4 "Alguel"     : nome -> Aluguel ; data 2026-05-11 -> 2026-11-05
-- Status: FEITO e conferido no Supabase (24/10). As 3 correções estão certas
--         e as outras linhas ficaram intactas (WHERE usado corretamente).
-- -----------------------------------------------------
-- Modelo de resposta:
-- SELECT * FROM aula01.despesa WHERE id_despesa = 2;   -- conferir antes
-- UPDATE aula01.despesa SET data_venc = '2026-11-10' WHERE id_despesa = 2;
-- UPDATE aula01.despesa SET descricao = 'Aluguel', data_venc = '2026-11-05'
-- WHERE id_despesa = 4;
--
-- O que aprendi:
--  * SELECT sem colunas (SELECT FROM tabela) não dá erro, mas não mostra nada.
--    Precisa de * ou da lista de colunas.
--  * O ; encerra o comando. "SELECT ... ;" seguido de "WHERE ..." dá erro de
--    sintaxe perto do WHERE: o WHERE ficou sozinho. Um ; só, no final de tudo.
--  * Autocompletar do SQL Editor: com a lista de sugestões aberta, o Enter aceita
--    a sugestão. Apertar Esc antes do Enter.


-- -----------------------------------------------------
-- Exercício 2 - public.funcionario: nome e escolaridade dos MESTRES,
-- em ordem alfabética de nome
-- Status: FEITO (consulta não enviada para correção)
-- -----------------------------------------------------
-- Modelo de resposta (2 linhas: ALESSANDRO, ANDRE):
-- SELECT nome, escolaridade FROM funcionario
-- WHERE escolaridade = 'MESTRE'
-- ORDER BY nome;


-- -----------------------------------------------------
-- Exercício 3 - public.cargo: descrição e valor dos cargos acima de 2000,
-- do maior valor para o menor
-- Status: FEITO (26/10)
-- -----------------------------------------------------
-- Tentativa: ORDER BY DESC;  -> erro: faltou dizer POR QUAL COLUNA ordenar.
-- Certo (4 linhas, começa no DBA ORACLE 7900):
SELECT descricao, valor FROM cargo
WHERE valor > 2000
ORDER BY valor DESC;


-- -----------------------------------------------------
-- Exercício 4 - public.funcionario: nome e escolaridade de quem é
-- DOUTOR ou MESTRE (usar IN), ordenado por escolaridade e depois nome
-- Status: FEITO (26/10), depois de 2 tentativas
-- -----------------------------------------------------
-- Tentativa 1: SELECT * FROM funcionario  (sem ;) + outro SELECT -> comandos grudados
--              WHERE escolaridade = 'DOUTOR' OR 'MESTRE'  -> o lado direito do OR
--              precisa ser uma condição completa
-- Tentativa 2: WHERE escolaridade = 'DOUTOR' IN 'MESTRE' -> IN usa lista entre ( )
-- Certo (4 linhas: ALEXANDRE, FERNANDO, ALESSANDRO, ANDRE):
SELECT nome, escolaridade FROM funcionario
WHERE escolaridade IN ('DOUTOR', 'MESTRE')
ORDER BY escolaridade, nome;
-- Equivalente: WHERE escolaridade = 'DOUTOR' OR escolaridade = 'MESTRE'
-- Lembrete: em "ORDER BY escolaridade, nome ASC" o ASC vale só para nome.


-- -----------------------------------------------------
-- Exercício 5 - DELETE com segurança (aula01.despesa)
--   a) inserir a despesa 'Teste', 10.00, '2026-12-01'
--   b) SELECT que mostre só essa linha
--   c) DELETE usando o mesmo WHERE
--   d) explicar: o que faria DELETE FROM aula01.despesa; (sem WHERE)?
-- Status: FEITO (26/10) - conferido no Supabase, voltou a 3 linhas
-- -----------------------------------------------------
INSERT INTO aula01.despesa (descricao, valor, data_venc)
VALUES ('Teste', 10.00, '2026-12-01');      -- recebeu o id 5

SELECT * FROM aula01.despesa WHERE id_despesa = 5;

DELETE FROM aula01.despesa WHERE id_despesa = 5;
-- Erros na tentativa: "DELETE * FROM" -> DELETE não leva * (apaga sempre a
-- linha inteira); id entre aspas '5' -> número vai sem aspas.
--
-- d) Resposta do Mateus: "deletaria a tabela inteira".
--    Ajuste: apagaria TODAS AS LINHAS, mas a TABELA continua existindo, vazia.
--    Quem apaga a tabela (estrutura + dados) é o DROP TABLE.
