-- =====================================================
-- Chave estrangeira, alias e JOIN com 3 tabelas (entregue em 14/11)
-- =====================================================

-- K1 - (public) nome do funcionário, descrição do cargo e valor AS salario,
--      com apelidos f e c, do maior salário para o menor
--      (dados atuais: 7 linhas, começa nos ADMINISTRADORES DE BANCO DE DADOS 7020)
-- (resolução do Mateus)

-- K2 - (exercicio_relacionamento) INSERT INTO matricula (ra, id_curso, periodo)
--      VALUES (999, 1, 'Noite');  -> o que aconteceu e por quê?
--      (esperado: erro de FK matricula_ra_fkey: o aluno 999 não existe)
-- (resolução do Mateus)

-- K3 - nome do aluno, nome do curso e período dos alunos de Franca, por nome
--      (esperado 5 linhas; Ana aparece 2x porque tem 2 matrículas: ADS e Redes)
-- (resolução do Mateus)

-- K4 - curso sem nenhum aluno (curso LEFT JOIN matricula WHERE m.ra IS NULL)
--      (esperado: Engenharia de Software)
-- (resolução do Mateus)

-- K5 - (sem rodar) DROP TABLE curso; -> erro: matricula depende de curso (FK)
-- (resolução do Mateus)
