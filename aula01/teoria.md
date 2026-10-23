# Aula 01 — O que é um banco de dados e a primeira tabela

## Conceitos

Um banco de dados relacional é um conjunto de **tabelas** que se relacionam entre si.

| Termo | No Excel seria... |
|---|---|
| Tabela | Uma aba da planilha |
| Coluna (campo) | O cabeçalho da coluna |
| Linha (registro) | Uma linha preenchida |
| Chave primária | Um código que nunca se repete |
| Schema | Uma "pasta" que agrupa tabelas |

Vantagem sobre o Excel: o banco **obriga regras** (tipo de dado, campo obrigatório, chave única).

## Tipos de dados mais usados (PostgreSQL)

- `INTEGER` — número inteiro
- `NUMERIC(10,2)` — decimal exato, **usar para dinheiro** (10 dígitos, 2 após a vírgula)
- `VARCHAR(n)` — texto de até n caracteres
- `TEXT` — texto sem limite
- `DATE` — data no formato `'AAAA-MM-DD'`
- `BOOLEAN` — `TRUE` / `FALSE`
- `SERIAL` — inteiro numerado automaticamente pelo banco

## Comandos

```sql
-- criar uma "pasta" para a aula
CREATE SCHEMA aula01;

-- criar tabela
CREATE TABLE aula01.membro (
  id_membro   SERIAL PRIMARY KEY,
  nome        VARCHAR(100) NOT NULL,   -- NOT NULL = obrigatório
  data_nasc   DATE,
  renda       NUMERIC(10,2)
);

-- inserir dados (texto e data entre aspas simples; decimal com ponto)
INSERT INTO aula01.membro (nome, data_nasc, renda) VALUES
  ('Mateus', '1998-05-10', 3500.00),
  ('Ana',    '2000-02-20', 4200.50),
  ('Pedro',  '2015-08-01', NULL);      -- NULL = vazio / desconhecido

-- consultar
SELECT * FROM aula01.membro;             -- todas as colunas
SELECT nome, renda FROM aula01.membro;   -- só as colunas escolhidas
```

## Lembretes

- Cada coluna termina com vírgula, menos a última.
- Todo comando termina com `;`.
- `--` é comentário.
- O `SERIAL` preenche o código sozinho: não precisa informar no `INSERT`.
