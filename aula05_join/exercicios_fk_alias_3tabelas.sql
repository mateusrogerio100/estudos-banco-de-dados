-- =====================================================
-- Chave estrangeira, alias e JOIN com 3 tabelas (14/11 entregue, 15/11 feito)
-- =====================================================

-- K1 - (public) funcionário, cargo e salário com apelidos, maior -> menor  FEITO
--   Erro: colocou SET search_path TO exercicio_relacionamento -> funcionario/cargo
--   estão no public (relation does not exist). O resto estava certo.
select f.nome, c.descricao, c.valor as salario
from funcionario f
inner join cargo c on f.id_cargo = c.id_cargo
order by c.valor desc;

SET search_path TO exercicio_relacionamento;

-- K2 - INSERT INTO matricula (ra, id_curso, periodo) VALUES (999, 1, 'Noite');  FEITO
--   Resposta: recusado porque o RA 999 não existe na tabela aluno -> CERTO.
--   Erro: violates foreign key constraint "matricula_ra_fkey". Nada é gravado.

-- K3 - alunos de Franca com curso e período, por nome -> 5 linhas  FEITO (2ª tentativa)
--   Erros: 1) JOIN do curso antes da matrícula usando m.id_curso -> "m" ainda
--   não existia (missing FROM-clause entry). As pontes vão em ordem:
--   aluno -> matricula -> curso. 2) "is "Franca"" -> IS é só p/ NULL e aspas
--   duplas são p/ nomes de coluna; certo: = 'Franca'.
--   Ana aparece 2x porque tem 2 matrículas (ADS e Redes): JOIN = 1 linha por par.
select a.nome, c.nome_curso, m.periodo
from aluno a
inner join matricula m on m.ra = a.ra
inner join curso c on c.id_curso = m.id_curso
where a.cidade = 'Franca'
order by a.nome;

-- K4 - curso sem nenhum aluno -> Engenharia de Software  FEITO (2ª tentativa)
--   Erro: usou o apelido "a" (do K3) no ON; aqui os apelidos são c e m.
select c.nome_curso, m.id_curso as matriculado
from curso c
left join matricula m on m.id_curso = c.id_curso
where m.id_curso is null;

-- K5 - (teoria) DROP TABLE curso;  FEITO
--   Resposta: "o banco não deixaria, porque curso está relacionada com matricula;
--   teria que dropar matricula primeiro e depois curso" -> CERTO.
--   Outras saídas: ALTER TABLE matricula DROP CONSTRAINT matricula_id_curso_fkey;
--   ou DROP TABLE curso CASCADE (apaga a FK que depende dela - cuidado).
