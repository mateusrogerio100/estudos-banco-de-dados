-- =====================================================
-- AULA 03 - Exercícios
-- SEQUENCE, CONSTRAINT (PK, UNIQUE, NOT NULL, DEFAULT), ALTER TABLE
-- Schema: aula03
-- =====================================================

-- Exercício 1 - Sequence + tabela com constraints nomeadas
--   aula03.seq_fornecedor (incremento 1, mínimo 1)
--   aula03.fornecedor: id_fornecedor (INTEGER, default da sequence),
--   razao_social VARCHAR(80) obrigatório, cnpj VARCHAR(18) obrigatório,
--   cidade VARCHAR(40); CONSTRAINT pk_fornecedor e uq_fornecedor_cnpj
-- (resolução do Mateus)


-- Exercício 2 - INSERT e o UNIQUE em ação
--   Energia Paulista S.A.     | 11.111.111/0001-11 | Ribeirão Preto
--   Distribuidora Medsul Ltda | 22.222.222/0001-22 | Franca
--   Papelaria Central ME      | 33.333.333/0001-33 | Franca
--   depois: 'Medsul Filial', 22.222.222/0001-22 -> explicar o erro
--   (esperado: duplicate key ... "uq_fornecedor_cnpj")
-- (resolução do Mateus)


-- Exercício 3 - ALTER TABLE
--   a) adicionar email VARCHAR(100)
--   b) adicionar ativo BOOLEAN obrigatório, padrão TRUE
--   c) remover a coluna cidade
--   d) SELECT * para conferir (razao_social, cnpj, email vazio, ativo true)
-- (resolução do Mateus)


-- Exercício 4 - O erro do NOT NULL
--   ALTER TABLE aula03.fornecedor ADD COLUMN telefone VARCHAR(15) NOT NULL;
--   -> explicar o erro (contains null values) e resolver de 2 jeitos
--      (sem NOT NULL / com DEFAULT)
-- (resolução do Mateus)


-- Exercício 5 - Remover e recriar uma constraint
--   a) DROP CONSTRAINT uq_fornecedor_cnpj
--   b) inserir de novo a 'Medsul Filial' (agora entra)
--   c) tentar recriar a constraint -> explicar o erro
--   d) apagar a filial (WHERE razao_social = 'Medsul Filial') e recriar
-- (resolução do Mateus)
