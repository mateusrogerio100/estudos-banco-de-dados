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
-- Status: feito pelo Mateus, consulta ainda não enviada para correção
--         (resultado esperado: 2 linhas - ALESSANDRO e ANDRE)
-- -----------------------------------------------------
-- (resolução do Mateus)


-- -----------------------------------------------------
-- Exercício 3 - public.cargo: descrição e valor dos cargos acima de 2000,
-- do maior valor para o menor
-- Status: PAROU AQUI (próximo a fazer)
-- -----------------------------------------------------
-- (resolução do Mateus)


-- -----------------------------------------------------
-- Exercício 4 - public.funcionario: nome e escolaridade de quem é
-- DOUTOR ou MESTRE (usar IN), ordenado por escolaridade e depois nome
-- -----------------------------------------------------
-- (resolução do Mateus)


-- -----------------------------------------------------
-- Exercício 5 - DELETE com segurança (aula01.despesa)
--   a) inserir a despesa 'Teste', 10.00, '2026-12-01'
--   b) SELECT que mostre só essa linha
--   c) DELETE usando o mesmo WHERE
--   d) explicar: o que faria DELETE FROM aula01.despesa; (sem WHERE)?
-- -----------------------------------------------------
-- (resolução do Mateus)
