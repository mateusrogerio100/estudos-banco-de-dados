-- =====================================================================
-- EXERCÍCIO 08 - Banco de Dados (professor)
-- Resolução comentada
-- =====================================================================


-- =====================================================================
-- QUESTÃO 1 - Criar o banco de dados
-- =====================================================================
-- Resposta para ENTREGAR ao professor (PostgreSQL instalado / pgAdmin):
--
--   CREATE DATABASE "EXERCICIO_RELACIONAMENTO"
--   TEMPLATE = template0
--   ENCODING = 'WIN1252';
--
-- No SUPABASE não dá para criar outro banco, então usamos um SCHEMA
-- (uma "pasta" dentro do banco) com o mesmo papel:

CREATE SCHEMA IF NOT EXISTS exercicio_relacionamento;

-- Daqui para baixo, todas as tabelas vão para essa pasta:
SET search_path TO exercicio_relacionamento;


-- =====================================================================
-- QUESTÃO 2 - Criar as tabelas conforme o modelo
-- =====================================================================
-- Ordem importa: primeiro CLIENTE, depois PEDIDO (que aponta para cliente).
-- SERIAL = o banco numera o código sozinho (os INSERTs não informam o id).

CREATE TABLE cliente (
    id_cliente   SERIAL,
    nm_cliente   VARCHAR(60),
    nm_endereco  VARCHAR(100),
    nm_cidade    VARCHAR(40),
    fg_ativo     INTEGER,
    PRIMARY KEY (id_cliente)
);

CREATE TABLE pedido (
    id_pedido    SERIAL,
    id_cliente   INTEGER,
    nr_pedido    INTEGER,
    fg_ativo     INTEGER,
    PRIMARY KEY (id_pedido)
    -- FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
);

-- POR QUE A CHAVE ESTRANGEIRA ESTÁ COMENTADA?
-- O último INSERT de pedido usa o cliente 15, que NÃO existe.
-- Com a FOREIGN KEY ativa, o banco recusa esse pedido (e, como o INSERT é
-- "tudo ou nada", recusa os 5 pedidos juntos).
-- O exercício colocou esse pedido "órfão" de propósito: é ele que mostra a
-- diferença entre RIGHT JOIN e FULL JOIN nas questões 6 e 7.
-- Se o professor quiser a FK, o pedido do cliente 15 deve ser retirado.


-- =====================================================================
-- QUESTÃO 3 - Inserir os registros
-- =====================================================================
INSERT INTO CLIENTE (NM_CLIENTE, NM_ENDERECO, NM_CIDADE, FG_ATIVO)
VALUES
('HUGO DA SILVA MACHADO', 'RUA PEREIRA LAGO, 34 - BAIRRO CAMPOS ELÍSEOS', 'RIBEIRÃO PRETO', 1),
('TIAGO NUNES BERNARDO', 'AV FRANCISCO JUNQUEIRA, 1208 - APTO 45 - BAIRRO MOCA', 'SÃO PAULO', 1),
('SABRINA JOAQUINA SILVEIRA', 'RUA NASCIMENTO, 234 - BAIRRO CENTRO', 'MOCOCA', 1);

INSERT INTO PEDIDO (ID_CLIENTE, NR_PEDIDO, FG_ATIVO)
VALUES
(3, 77895, 1),
(3, 44678, 1),
(1, 22456, 1),
(1, 24562, 1),
(15, 34764, 1);

-- Situação dos dados (importante para entender os JOINs):
--   HUGO (1)    -> 2 pedidos
--   TIAGO (2)   -> NENHUM pedido   (cliente sem pedido)
--   SABRINA (3) -> 2 pedidos
--   pedido 34764 -> cliente 15, que não existe (pedido sem cliente)


-- =====================================================================
-- QUESTÃO 4 - Clientes QUE TÊM pedido  ->  JOIN (INNER JOIN)
-- =====================================================================
-- Só aparecem linhas que "casam" nas DUAS tabelas.
-- Tiago (sem pedido) e o pedido 34764 (sem cliente) ficam de fora.
SELECT p.nr_pedido,
       c.nm_cliente
FROM cliente c
INNER JOIN pedido p ON (c.id_cliente = p.id_cliente)
ORDER BY c.nm_cliente;


-- =====================================================================
-- QUESTÃO 5 - TODOS os clientes (e seus pedidos)  ->  LEFT JOIN
-- =====================================================================
-- Tabela da ESQUERDA (cliente) aparece inteira.
-- Tiago aparece com o pedido vazio (NULL).
SELECT c.nm_cliente,
       p.nr_pedido
FROM cliente c
LEFT OUTER JOIN pedido p ON (c.id_cliente = p.id_cliente)
ORDER BY c.nm_cliente;


-- =====================================================================
-- QUESTÃO 6 - TODOS os pedidos (e seus clientes)  ->  RIGHT JOIN
-- =====================================================================
-- Tabela da DIREITA (pedido) aparece inteira.
-- O pedido 34764 aparece com o cliente vazio (NULL).
SELECT c.nm_cliente,
       p.nr_pedido
FROM cliente c
RIGHT OUTER JOIN pedido p ON (c.id_cliente = p.id_cliente)
ORDER BY c.nm_cliente;


-- =====================================================================
-- QUESTÃO 7 - Todos os clientes E todos os pedidos  ->  FULL JOIN
-- =====================================================================
-- Junta o LEFT e o RIGHT: aparecem o Tiago (sem pedido)
-- E o pedido 34764 (sem cliente).
SELECT c.nm_cliente,
       p.nr_pedido
FROM cliente c
FULL OUTER JOIN pedido p ON (c.id_cliente = p.id_cliente)
ORDER BY c.nm_cliente;


-- =====================================================================
-- QUESTÕES 8 a 10 - Alterar tabelas já criadas  ->  ALTER TABLE
-- =====================================================================
-- 8. Adicionar coluna email em cliente
ALTER TABLE cliente ADD COLUMN email VARCHAR(100);

-- 9. Adicionar coluna valor em pedido
ALTER TABLE pedido ADD COLUMN valor NUMERIC(15,2);

-- 10. Remover a coluna fg_ativo de pedido
ALTER TABLE pedido DROP COLUMN fg_ativo;


-- =====================================================================
-- QUESTÃO 11 - Criar curso, aluno e matricula
-- =====================================================================
-- Aqui o código NÃO é SERIAL: o exercício informa os números (1..5, 101..112).

-- T1
CREATE TABLE curso (
    id_curso    INT,
    nome_curso  VARCHAR(80) NOT NULL,
    area        VARCHAR(40) NOT NULL,
    PRIMARY KEY (id_curso)
);

-- T2
CREATE TABLE aluno (
    ra              INT,
    nome            VARCHAR(100) NOT NULL,
    cidade          VARCHAR(60)  NOT NULL,
    ano_nascimento  INT          NOT NULL,
    PRIMARY KEY (ra)
);

-- T3 - tabela de ligação (um aluno pode ter vários cursos e vice-versa)
-- Chave primária COMPOSTA: o mesmo aluno não se matricula 2x no mesmo curso.
CREATE TABLE matricula (
    ra        INT         NOT NULL,
    id_curso  INT         NOT NULL,
    periodo   VARCHAR(15) NOT NULL,   -- 'Manhã' ou 'Noite'
    PRIMARY KEY (ra, id_curso),
    FOREIGN KEY (ra)       REFERENCES aluno (ra),
    FOREIGN KEY (id_curso) REFERENCES curso (id_curso)
);


-- =====================================================================
-- QUESTÃO 12 - Inserir os dados
-- =====================================================================
-- I1. Cursos
INSERT INTO curso (id_curso, nome_curso, area) VALUES
(1, 'Análise e Desenvolvimento de Sistemas', 'Tecnologia'),
(2, 'Ciência da Computação',                 'Graduação'),
(3, 'Sistemas de Informação',                'Graduação'),
(4, 'Engenharia de Software',                'Graduação'),
(5, 'Redes de Computadores',                 'Tecnologia');

-- I2. Alunos
INSERT INTO aluno (ra, nome, cidade, ano_nascimento) VALUES
(101, 'Ana Beatriz Souza',         'Franca',               2005),
(102, 'Bruno Carvalho Lima',       'Ribeirão Preto',       2004),
(103, 'Carla Menezes Rocha',       'Batatais',             2003),
(104, 'Diego Fernandes Alves',     'Ituverava',            2005),
(105, 'Eduarda Ramos Martins',     'Franca',               2002),
(106, 'Felipe Gomes Pinto',        'São Joaquim da Barra', 2004),
(107, 'Gabriela Nunes dos Santos', 'Franca',               2001),
(108, 'Heitor Almeida Barros',     'Claraval',             2005),
(109, 'Isabela Duarte Campos',     'Ribeirão Preto',       2003),
(110, 'João Vitor Siqueira',       'Franca',               2002),
(111, 'Larissa Costa Peixoto',     'Orlandia',             2004),
(112, 'Marcelo Tavares Braga',     'Ipuã',                 2003);

-- I3. Matrículas (aluno 112 sem curso; curso 4 sem alunos)
-- Precisa vir DEPOIS de curso e aluno, por causa das chaves estrangeiras.
INSERT INTO matricula (ra, id_curso, periodo) VALUES
(101, 1, 'Noite'),
(102, 1, 'Noite'),
(103, 2, 'Manhã'),
(104, 2, 'Noite'),
(105, 3, 'Manhã'),
(106, 3, 'Manhã'),
(107, 2, 'Noite'),
(108, 1, 'Noite'),
(109, 3, 'Noite'),
(110, 5, 'Manhã'),
(111, 5, 'Noite'),
(101, 5, 'Noite'),
(104, 1, 'Noite'),
(106, 1, 'Manhã'),
(108, 5, 'Manhã');


-- =====================================================================
-- QUESTÃO 13 - Todos os alunos, nome em ordem crescente (A -> Z)
-- =====================================================================
SELECT *
FROM aluno
ORDER BY nome;            -- ASC (crescente) é o padrão, não precisa escrever


-- =====================================================================
-- QUESTÃO 14 - Mesma lista, ordem decrescente (Z -> A)
-- =====================================================================
SELECT *
FROM aluno
ORDER BY nome DESC;


-- =====================================================================
-- QUESTÃO 15 - Aliases de coluna, do mais NOVO para o mais VELHO
-- =====================================================================
-- Mais novo = nasceu DEPOIS = ano MAIOR -> ordem decrescente do ano.
SELECT ra             AS ra_aluno,
       nome           AS nome_aluno,
       ano_nascimento AS nascimento
FROM aluno
ORDER BY ano_nascimento DESC;


-- =====================================================================
-- QUESTÃO 16 - Cursos com aliases, ordenados pelo nome do curso
-- =====================================================================
SELECT id_curso   AS codigo,
       nome_curso AS curso
FROM curso
ORDER BY nome_curso;


-- =====================================================================
-- QUESTÃO 17 - Nascidos em 2004 ou 2005, por cidade e depois nome
-- =====================================================================
SELECT nome   AS nome_aluno,
       cidade AS cidade_aluno
FROM aluno
WHERE ano_nascimento = 2004
   OR ano_nascimento = 2005          -- ou: WHERE ano_nascimento IN (2004, 2005)
ORDER BY cidade, nome;               -- empate na cidade -> desempata pelo nome


-- =====================================================================
-- QUESTÃO 18 - Alias de TABELA (a) para qualificar as colunas
-- =====================================================================
-- "aluno a" = apelido da tabela; "a.ra" = coluna ra da tabela a.
SELECT a.ra AS ra_aluno,
       a.nome,
       a.cidade,
       a.ano_nascimento
FROM aluno a
ORDER BY a.cidade, a.nome;


-- =====================================================================
-- QUESTÃO 19 - Aluno e curso em que está matriculado (JOIN)
-- =====================================================================
-- O aluno não liga direto no curso: o caminho é aluno -> matricula -> curso.
-- Por isso são DOIS joins.
SELECT a.nome       AS aluno,
       c.nome_curso AS matriculado_em
FROM aluno a
JOIN matricula m ON (a.ra = m.ra)
JOIN curso c     ON (m.id_curso = c.id_curso)
ORDER BY c.nome_curso, a.nome;


-- =====================================================================
-- QUESTÃO 20 - Cursos que têm alunos, com o turno
-- =====================================================================
-- JOIN só traz cursos que aparecem em matricula (o curso 4 fica de fora).
-- DISTINCT tira as linhas repetidas: sem ele, "ADS - Noite" apareceria
-- uma vez para cada aluno matriculado nesse curso e turno.
SELECT DISTINCT
       c.nome_curso AS oferecido,
       m.periodo    AS turno
FROM curso c
JOIN matricula m ON (c.id_curso = m.id_curso)
ORDER BY c.nome_curso ASC, m.periodo DESC;


-- =====================================================================
-- QUESTÃO 21 - TODOS os alunos, com ou sem curso (LEFT JOIN)
-- =====================================================================
-- Os DOIS joins precisam ser LEFT: se o segundo fosse JOIN comum, o
-- Marcelo (112, sem matrícula) seria eliminado no segundo passo.
SELECT a.nome       AS nome_completo,
       c.nome_curso AS nome_do_curso
FROM aluno a
LEFT JOIN matricula m ON (a.ra = m.ra)
LEFT JOIN curso c     ON (m.id_curso = c.id_curso)
ORDER BY a.nome;


-- =====================================================================
-- QUESTÃO 22 - Matrículas no turno da Noite
-- =====================================================================
-- O período está na matricula, e o nome está em aluno: basta juntar as duas.
SELECT a.ra   AS ra_aluno,
       a.nome AS nome_aluno
FROM aluno a
JOIN matricula m ON (a.ra = m.ra)
WHERE m.periodo = 'Noite'
ORDER BY a.ra;
