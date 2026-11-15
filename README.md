# Estudos de Banco de Dados

Material de estudo da disciplina de Banco de Dados (PostgreSQL / Supabase).

## Contexto

O arquivo [CONTEXTO.txt](CONTEXTO.txt) guarda o plano das aulas e onde paramos.

## Organização

Cada aula tem sua própria pasta e, no Supabase, seu próprio **schema** (`aula01`, `aula02`, ...).
Assim as tabelas de uma aula não se misturam com as de outra.

| Pasta | Assunto |
|---|---|
| [aula01](aula01/) | Conceitos básicos, tipos de dados, `CREATE TABLE`, `INSERT`, `SELECT` |
| [aula02](aula02/) | `WHERE`, `ORDER BY`, `UPDATE`, `DELETE` |
| [revisao01](revisao01/) | Revisão das Aulas 01 e 02 |
| [aula03](aula03/) | `CREATE DATABASE`, `SEQUENCE`, constraints, `ALTER TABLE` |

Em cada pasta:
- `teoria.md` — resumo da aula
- `exercicios.sql` — exercícios resolvidos

## Exercícios do professor

| Arquivo | Assunto |
|---|---|
| [professor/exercicio08.sql](professor/exercicio08.sql) | Chave estrangeira, JOIN / LEFT / RIGHT / FULL, ALTER TABLE, ORDER BY, alias |

## Lista de exercícios para a prova

[Lista_Exercicios_Prova.docx](Lista_Exercicios_Prova.docx): 40 questões (clínica médica). Gabarito: [lista/gabarito.sql](lista/gabarito.sql) — só depois de tentar!

## Visualizador de JOIN

[visualizador/join.html](visualizador/join.html): página interativa que mostra cliente × pedido e o resultado de cada tipo de JOIN.

## Resumo para a prova

O arquivo **[Resumo_Banco_de_Dados.docx](Resumo_Banco_de_Dados.docx)** junta a teoria de todas as aulas num só lugar.
Ele é gerado pelo script `ferramentas/gerar_resumo.js` e atualizado a cada aula nova.
