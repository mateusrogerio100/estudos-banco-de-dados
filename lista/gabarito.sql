-- =====================================================================
-- LISTA DE EXERCÍCIOS PARA A PROVA - GABARITO
-- (só abra DEPOIS de tentar!)  Schema no Supabase: lista
-- =====================================================================

-- ======================= PARTE A - ESTRUTURA =========================
-- 1) Na prova (pgAdmin):
--    CREATE DATABASE "CLINICA" TEMPLATE = template0 ENCODING = 'WIN1252';
--    No Supabase:
CREATE SCHEMA lista;
SET search_path TO lista;

-- 2)
CREATE SEQUENCE seq_especialidade INCREMENT 1 MINVALUE 1;
CREATE TABLE especialidade (
  id_especialidade INTEGER DEFAULT NEXTVAL('seq_especialidade'),
  nome             VARCHAR(40) NOT NULL,
  CONSTRAINT pk_especialidade      PRIMARY KEY (id_especialidade),
  CONSTRAINT uq_especialidade_nome UNIQUE (nome)
);

-- 3)
CREATE TABLE medico (
  id_medico        SERIAL,
  nome             VARCHAR(60)   NOT NULL,
  crm              VARCHAR(10)   NOT NULL,
  id_especialidade INTEGER,
  valor_consulta   NUMERIC(10,2) NOT NULL,
  CONSTRAINT pk_medico     PRIMARY KEY (id_medico),
  CONSTRAINT uq_medico_crm UNIQUE (crm),
  CONSTRAINT fk_medico_especialidade FOREIGN KEY (id_especialidade)
             REFERENCES especialidade (id_especialidade)
);

-- 4)
CREATE TABLE paciente (
  id_paciente    SERIAL PRIMARY KEY,
  nome           VARCHAR(60) NOT NULL,
  cidade         VARCHAR(40) NOT NULL,
  ano_nascimento INTEGER     NOT NULL
);

-- 5)
CREATE TABLE consulta (
  id_consulta   SERIAL,
  id_medico     INTEGER       NOT NULL,
  id_paciente   INTEGER       NOT NULL,
  data_consulta DATE          NOT NULL,
  valor         NUMERIC(10,2) NOT NULL,
  pago          BOOLEAN       NOT NULL DEFAULT FALSE,
  PRIMARY KEY (id_consulta),
  FOREIGN KEY (id_medico)   REFERENCES medico (id_medico),
  FOREIGN KEY (id_paciente) REFERENCES paciente (id_paciente)
);

-- 6) Ordem: especialidade -> medico -> paciente -> consulta (paciente pode vir
--    antes de medico). Quem tem FOREIGN KEY só pode ser criada depois da
--    tabela para a qual aponta ("pai" antes da "filha").

-- ======================= PARTE B - INSERIR ===========================
-- 7)
INSERT INTO especialidade (nome) VALUES
  ('Cardiologia'), ('Pediatria'), ('Ortopedia'), ('Dermatologia');

-- 8)
INSERT INTO medico (nome, crm, id_especialidade, valor_consulta) VALUES
  ('Dr. Paulo Mendes',       '1001', 1,    350.00),
  ('Dra. Carla Reis',        '1002', 2,    280.00),
  ('Dr. Rafael Lima',        '1003', 1,    400.00),
  ('Dra. Beatriz Nogueira',  '1004', 3,    320.00),
  ('Dr. Otávio Prado',       '1005', NULL, 250.00);

-- 9)
INSERT INTO paciente (nome, cidade, ano_nascimento) VALUES
  ('Marcos Antunes',       'Franca',         1980),
  ('Juliana Freitas',      'Ribeirão Preto', 1992),
  ('Pedro Henrique Silva', 'Franca',         2015),
  ('Luana Castro',         'Batatais',       1975),
  ('Roberto Dias',         'Franca',         1960);

-- 10) pagas (informa pago) e não informadas (DEFAULT FALSE)
INSERT INTO consulta (id_medico, id_paciente, data_consulta, valor, pago) VALUES
  (1, 1, '2026-11-03', 350.00, TRUE),
  (2, 3, '2026-11-04', 280.00, TRUE),
  (3, 2, '2026-11-05', 400.00, TRUE);
INSERT INTO consulta (id_medico, id_paciente, data_consulta, valor) VALUES
  (1, 4, '2026-11-05', 350.00),
  (5, 1, '2026-11-10', 250.00),
  (2, 3, '2026-11-12', 280.00),
  (3, 4, '2026-11-12', 400.00);
-- ids: 1 Paulo/Marcos | 2 Carla/Pedro | 3 Rafael/Juliana | 4 Paulo/Luana
--      5 Otávio/Marcos | 6 Carla/Pedro | 7 Rafael/Luana

-- 11) INSERT INTO consulta (id_medico, id_paciente, data_consulta, valor)
--     VALUES (99, 1, '2026-11-15', 300.00);
--     ERRO: violates foreign key constraint "consulta_id_medico_fkey" -
--     o médico 99 não existe. Nada é gravado (mas gasta 1 número da sequence).

-- 12) INSERT INTO medico (nome, crm, valor_consulta) VALUES ('Dr. Teste','1001',100);
--     ERRO: duplicate key value violates unique constraint "uq_medico_crm".

-- ======================= PARTE C - CONSULTAS =========================
-- 13) 3 linhas: Marcos, Pedro Henrique, Roberto
SELECT nome FROM paciente WHERE cidade = 'Franca' ORDER BY nome;

-- 14) 3 linhas: Rafael 400, Paulo 350, Beatriz 320
SELECT nome, valor_consulta FROM medico
WHERE valor_consulta > 300
ORDER BY valor_consulta DESC;

-- 15) 4 linhas: 05/11 (350), 10/11 (250), 12/11 (280), 12/11 (400)
SELECT id_consulta, data_consulta, valor FROM consulta
WHERE pago = FALSE
ORDER BY data_consulta;

-- 16) 3 linhas: Pedro Henrique 2015, Luana 1975, Roberto 1960
SELECT nome, ano_nascimento FROM paciente
WHERE ano_nascimento < 1980 OR ano_nascimento > 2010
ORDER BY ano_nascimento DESC;

-- 17) 4 linhas: consultas 2, 3, 4, 5
SELECT id_consulta, data_consulta FROM consulta
WHERE data_consulta >= '2026-11-04' AND data_consulta <= '2026-11-10'
ORDER BY data_consulta;
--     (equivalente: WHERE data_consulta BETWEEN '2026-11-04' AND '2026-11-10')

-- 18) 1 linha: Dr. Otávio Prado
SELECT nome FROM medico WHERE id_especialidade IS NULL;

-- 19) 4 linhas: Luana (Batatais), Marcos, Pedro Henrique, Roberto (Franca)
SELECT nome, cidade FROM paciente
WHERE cidade IN ('Franca', 'Batatais')
ORDER BY cidade, nome;

-- ======================= PARTE D - UPDATE / DELETE ===================
-- 20) consulta da Luana em 05/11 = id 4
SELECT * FROM consulta WHERE id_consulta = 4;
UPDATE consulta SET pago = TRUE WHERE id_consulta = 4;

-- 21)
UPDATE medico SET valor_consulta = 300.00 WHERE id_medico = 2;
--     As consultas antigas da Carla continuam 280: o valor da consulta foi
--     gravado na própria consulta (histórico) - o UPDATE em medico não muda isso.

-- 22)
DELETE FROM consulta WHERE id_consulta = 7;

-- 23) UPDATE consulta SET pago = TRUE;  (sem WHERE) -> TODAS as consultas
--     ficariam pagas. Correto seria filtrar pela chave primária.

-- ======================= PARTE E - ALTER TABLE =======================
-- 24)
ALTER TABLE paciente ADD COLUMN telefone VARCHAR(15);
-- 25) funciona por causa do DEFAULT (sem ele: "contains null values")
ALTER TABLE medico ADD COLUMN ativo BOOLEAN NOT NULL DEFAULT TRUE;
-- 26)
ALTER TABLE paciente DROP COLUMN telefone;
-- 27) DELETE FROM paciente WHERE id_paciente = 1;
--     ERRO: violates foreign key constraint "consulta_id_paciente_fkey" -
--     Marcos tem consultas. Teria que apagar as consultas dele antes.

-- ======================= PARTE F - JOINs =============================
-- (estado depois da Parte D: 6 consultas; a 4 está paga; a 7 foi apagada)

-- 28) 6 linhas
SELECT c.data_consulta, p.nome AS paciente, c.valor
FROM consulta c
INNER JOIN paciente p ON (p.id_paciente = c.id_paciente)
ORDER BY c.data_consulta;

-- 29) 4 linhas. Otávio some: id_especialidade dele é NULL, não casa com nada.
SELECT m.nome AS medico, e.nome AS especialidade
FROM medico m
INNER JOIN especialidade e ON (e.id_especialidade = m.id_especialidade);

-- 30) 5 linhas (Otávio com especialidade NULL)
SELECT m.nome AS medico, e.nome AS especialidade
FROM medico m
LEFT JOIN especialidade e ON (e.id_especialidade = m.id_especialidade)
ORDER BY m.nome;

-- 31) 5 linhas (Cardiologia 2x, Pediatria, Ortopedia, Dermatologia com médico NULL)
SELECT e.nome AS especialidade, m.nome AS medico
FROM medico m
RIGHT JOIN especialidade e ON (e.id_especialidade = m.id_especialidade)
ORDER BY e.nome;

-- 32) 6 linhas (Otávio sem especialidade + Dermatologia sem médico)
SELECT m.nome AS medico, e.nome AS especialidade
FROM medico m
FULL JOIN especialidade e ON (e.id_especialidade = m.id_especialidade);

-- 33) 6 linhas. Marcos e Pedro aparecem 2x (2 consultas cada)
SELECT c.data_consulta, m.nome AS medico, p.nome AS paciente, c.valor
FROM consulta c
JOIN medico m   ON (m.id_medico = c.id_medico)
JOIN paciente p ON (p.id_paciente = c.id_paciente)
ORDER BY c.data_consulta;

-- 34) 1 linha: Roberto Dias
SELECT p.nome
FROM paciente p
LEFT JOIN consulta c ON (c.id_paciente = p.id_paciente)
WHERE c.id_consulta IS NULL;

-- 35) 1 linha: Dra. Beatriz Nogueira
SELECT m.nome
FROM medico m
LEFT JOIN consulta c ON (c.id_medico = m.id_medico)
WHERE c.id_consulta IS NULL;

-- 36) 6 linhas, consulta do Otávio com especialidade NULL.
--     Se o último JOIN fosse INNER, a consulta do Otávio sumiria (5 linhas).
SELECT c.data_consulta, p.nome AS paciente, m.nome AS medico, e.nome AS especialidade
FROM consulta c
JOIN medico m        ON (m.id_medico = c.id_medico)
JOIN paciente p      ON (p.id_paciente = c.id_paciente)
LEFT JOIN especialidade e ON (e.id_especialidade = m.id_especialidade)
ORDER BY c.data_consulta;

-- 37) 2 linhas: 10/11 Marcos/Otávio 250 ; 12/11 Pedro/Carla 280
SELECT c.data_consulta, p.nome AS paciente, m.nome AS medico, c.valor
FROM consulta c
JOIN paciente p ON (p.id_paciente = c.id_paciente)
JOIN medico m   ON (m.id_medico = c.id_medico)
WHERE c.pago = FALSE
  AND p.cidade = 'Franca'
ORDER BY c.data_consulta;

-- ======================= PARTE G - CAÇA AOS ERROS ====================
-- 38) SELECT nome cidade FROM paciente
--     WHERE cidade = "Franca" OR 'Batatais'
--     ORDER BY DESC;
--  4 erros: falta vírgula (cidade vira apelido de nome, sem erro); aspas
--  duplas em "Franca" (vira nome de coluna); OR sem condição completa;
--  ORDER BY sem coluna.
SELECT nome, cidade FROM paciente
WHERE cidade = 'Franca' OR cidade = 'Batatais'
ORDER BY nome DESC;

-- 39) CREATE TABLE exame (
--       id_exame SERIAL PRIMARY KEY
--       id_consulta INTEGER NOT NULL,
--       descricao VARCHAR(60) NOT NULL,
--       FOREIGN KEY (id_consulta) REFERENCES consultas (id_consulta),
--     );
--  3 erros: falta vírgula após PRIMARY KEY; tabela "consultas" não existe
--  (é "consulta"); vírgula sobrando antes do ")".
CREATE TABLE exame (
  id_exame    SERIAL PRIMARY KEY,
  id_consulta INTEGER NOT NULL,
  descricao   VARCHAR(60) NOT NULL,
  FOREIGN KEY (id_consulta) REFERENCES consulta (id_consulta)
);

-- 40) SELECT p.nome, m.nome
--     FROM paciente p
--     JOIN medico m ON (m.id_medico = c.id_medico)
--     JOIN consulta c ON (c.id_paciente = p.id_paciente)
--     WHERE c.pago = NULL;
--  3 erros: ordem das pontes (usa c antes de apresentar); paciente não liga
--  direto em medico - o caminho é paciente -> consulta -> medico; "= NULL"
--  nunca encontra nada (e "pago" nem aceita NULL). Para não pagas: = FALSE.
--  Resultado (depois da Parte D): 2 linhas - Marcos/Otávio e Pedro/Carla.
SELECT p.nome AS paciente, m.nome AS medico
FROM paciente p
JOIN consulta c ON (c.id_paciente = p.id_paciente)
JOIN medico m   ON (m.id_medico = c.id_medico)
WHERE c.pago = FALSE;
