# Aula 02 — Filtrar, ordenar, alterar e excluir

Baseada nas Aulas 06 e 07 do professor (SQL – DML, cláusula WHERE, ORDER BY).

## DDL x DML

| Grupo | Para quê | Comandos |
|---|---|---|
| **DDL** (definição) | Mexe na **estrutura** | `CREATE`, `ALTER`, `DROP` |
| **DML** (manipulação) | Mexe nos **dados** | `INSERT`, `UPDATE`, `DELETE`, `SELECT` |

## WHERE — filtrar linhas

```sql
SELECT nome, escolaridade
FROM funcionario
WHERE escolaridade = 'MESTRE';
```

| Operador | Significa |
|---|---|
| `=` | igual |
| `<>` ou `!=` | diferente |
| `>` `<` `>=` `<=` | maior, menor, maior ou igual, menor ou igual |
| `AND` | as duas condições precisam ser verdadeiras |
| `OR` | basta uma ser verdadeira |
| `IN (a, b, c)` | igual a qualquer um da lista (atalho para vários OR) |
| `IS NULL` / `IS NOT NULL` | está vazio / não está vazio (**nunca** `= NULL`) |

## ORDER BY — ordenar

```sql
SELECT descricao, valor
FROM cargo
ORDER BY valor DESC;          -- DESC = decrescente; ASC (padrão) = crescente

ORDER BY escolaridade, nome;  -- desempate: primeiro escolaridade, depois nome
```
O `ORDER BY` vem **sempre por último** na consulta.

Ordem das cláusulas: `SELECT` → `FROM` → `WHERE` → `ORDER BY`

## UPDATE — alterar dados

```sql
UPDATE cargo
SET valor = 2500
WHERE id_cargo = 1;

UPDATE aluno
SET nome = 'Ana B. Souza', cidade = 'Franca'   -- várias colunas: separar por vírgula
WHERE ra = 101;
```

## DELETE — excluir linhas

```sql
DELETE FROM cargo
WHERE id_cargo = 7;
```

## ⚠️ A bomba do professor

`UPDATE` ou `DELETE` **sem WHERE** atinge **todas as linhas** da tabela:

```sql
UPDATE cargo SET valor = 5000;   -- TODOS os cargos passam a valer 5000
DELETE FROM cargo;               -- APAGA todos os cargos
```

Boa prática: antes de um UPDATE/DELETE, rode um **SELECT com o mesmo WHERE**
para ver exatamente quais linhas serão afetadas.
