# Aula 03 — Estrutura das tabelas

Baseada nas Aulas 06 e 07 do professor (SQL – DDL, CREATE DATABASE, SEQUENCE, ALTER TABLE).

## CREATE DATABASE (teoria — no Supabase usamos SCHEMA)

```sql
CREATE DATABASE "AULAS"
  OWNER = postgres          -- usuário dono do banco
  TEMPLATE = template0      -- modelo estrutural usado na criação
  ENCODING = 'WIN1252'      -- conjunto de caracteres
  TABLESPACE = pg_default   -- onde os arquivos ficam guardados
  CONNECTION LIMIT = -1;    -- limite de conexões (-1 = sem limite)

DROP DATABASE "AULAS";      -- apaga o banco inteiro
```
Só o NOME é obrigatório; evite espaços e caracteres especiais.

## SEQUENCE x SERIAL

```sql
CREATE SEQUENCE aula03.seq_fornecedor
  INCREMENT 1     -- de quanto em quanto
  MINVALUE 1;     -- começa em

CREATE TABLE aula03.fornecedor (
  id_fornecedor INTEGER DEFAULT NEXTVAL('aula03.seq_fornecedor'),
  ...
);
```
`SERIAL` faz exatamente isso automaticamente (cria a sequence `tabela_coluna_seq`).
O contador nunca volta atrás: um INSERT que falha "gasta" um número.

## Restrições (constraints)

| Restrição | Garante |
|---|---|
| `PRIMARY KEY` | identifica a linha: não repete e não fica vazia |
| `NOT NULL` | campo obrigatório |
| `UNIQUE` | não repete (mas pode ficar vazio) — ex.: CNPJ, CPF |
| `DEFAULT` | valor usado quando ninguém informa |
| `FOREIGN KEY` | aponta para outra tabela (Aula 04) |

Restrição com nome (estilo do professor):
```sql
CONSTRAINT pk_fornecedor      PRIMARY KEY (id_fornecedor),
CONSTRAINT uq_fornecedor_cnpj UNIQUE (cnpj)
```
O nome serve para remover/recriar depois e aparece nas mensagens de erro.

## ALTER TABLE — mudar a estrutura sem apagar os dados

```sql
ALTER TABLE aula03.fornecedor ADD COLUMN email VARCHAR(100);
ALTER TABLE aula03.fornecedor DROP COLUMN cidade;
ALTER TABLE aula03.fornecedor DROP CONSTRAINT uq_fornecedor_cnpj;
ALTER TABLE aula03.fornecedor ADD CONSTRAINT uq_fornecedor_cnpj UNIQUE (cnpj);
```

Regras dos slides:
- Coluna `NOT NULL` **sem DEFAULT** não pode ser adicionada em tabela que já tem
  dados (as linhas antigas ficariam vazias). Com `DEFAULT` funciona.
- Não remova a coluna da chave primária (o PostgreSQL até deixa, mas a tabela
  perde a chave).
- `DROP TABLE` não remove tabela referenciada por outra (chave estrangeira).

## DROP TABLE x ALTER TABLE

| Situação | Use |
|---|---|
| Tabela vazia, estrutura errada | `DROP TABLE` + `CREATE TABLE` |
| Tabela com dados | `ALTER TABLE` (preserva os dados) |
