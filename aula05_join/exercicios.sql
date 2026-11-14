-- =====================================================
-- JOIN (plano acelerado, 14/11) - INNER, LEFT, RIGHT, FULL
-- Schema: exercicio_relacionamento (cliente / pedido do Exercício 08)
-- Visualizador interativo: visualizador/join.html
-- =====================================================
SET search_path TO exercicio_relacionamento;

-- J1 - pedidos com o nome do cliente (só quem casou) -> 4 linhas
--   FEITO. Estava certo; o erro foi faltar o SET search_path (sem ele o banco
--   procura no public, onde não existe "pedido").
select pedido.nr_pedido as numero_pedido, cliente.nm_cliente as nome_cliente
from cliente
inner join pedido on (pedido.id_cliente = cliente.id_cliente);

-- J2 - todos os clientes e seus pedidos, ordenado por nome -> 5 linhas (TIAGO sem pedido)
--   FEITO. 1ª versão esqueceu o ORDER BY pedido no enunciado.
select pedido.nr_pedido as numero_pedido, cliente.nm_cliente as nome_cliente
from cliente
left join pedido on (pedido.id_cliente = cliente.id_cliente)
order by cliente.nm_cliente ASC;

-- J3 - todos os pedidos, inclusive sem cliente, com LEFT JOIN -> 5 linhas (34764 sem cliente)
--   FEITO de primeira: inverteu as tabelas (pedido no FROM).
select pedido.nr_pedido as numero_pedido, cliente.nm_cliente as nome_cliente
from pedido
left join cliente on cliente.id_cliente = pedido.id_cliente;

-- J4 - só os clientes que nunca fizeram pedido -> 1 linha (TIAGO)
--   Raciocínio certo; errou "= null" (resultado vazio, sem erro). Certo: IS NULL.
select pedido.nr_pedido as numero_pedido, cliente.nm_cliente as nome_cliente
from cliente
left join pedido on (pedido.id_cliente = cliente.id_cliente)
where pedido.nr_pedido is null
order by cliente.nm_cliente;

-- J5 - FULL JOIN balancete x títulos a receber (pergunta teórica)
--   Resposta do Mateus: "não foram casadas: lançamento só na contabilidade ou
--   só no financeiro" -> CERTO. Detalhando:
--     lado do BALANCETE vazio -> existe só nos títulos (financeiro), falta na contabilidade
--     lado dos TÍTULOS vazio  -> existe só no balancete (contábil), falta no financeiro
