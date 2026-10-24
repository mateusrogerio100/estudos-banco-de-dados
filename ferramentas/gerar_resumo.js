// Gera o arquivo "Resumo_Banco_de_Dados.docx" na raiz do repositório.
// A cada aula nova, acrescente o conteúdo dela no array AULAS e rode:  node ferramentas/gerar_resumo.js
const fs = require('fs');
const path = require('path');
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, HeadingLevel,
  AlignmentType, WidthType, ShadingType, BorderStyle, LevelFormat, PageBreak,
  TableOfContents, Footer, PageNumber,
} = require('docx');

const AZUL = '1F4E79';
const LARGURA = 9026; // A4 com margens de 1" (DXA)

// ---------- blocos de construção ----------
const p = (texto, opts = {}) => new Paragraph({
  spacing: { after: 120 },
  children: runs(texto),
  ...opts,
});
// **negrito** e `codigo` dentro do texto
function runs(texto) {
  const partes = texto.split(/(\*\*[^*]+\*\*|`[^`]+`)/g).filter(Boolean);
  return partes.map(t => {
    if (t.startsWith('**')) return new TextRun({ text: t.slice(2, -2), bold: true });
    if (t.startsWith('`')) return new TextRun({ text: t.slice(1, -1), font: 'Consolas', color: 'A31515' });
    return new TextRun(t);
  });
}
const h1 = (t, novaPagina) => new Paragraph({ heading: HeadingLevel.HEADING_1, pageBreakBefore: !!novaPagina, children: [new TextRun(t)] });
const h2 = t => new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun(t)] });
const bullet = t => new Paragraph({ numbering: { reference: 'bolinhas', level: 0 }, spacing: { after: 60 }, children: runs(t) });

function codigo(texto) {
  const linhas = texto.trim().split('\n');
  return linhas.map((l, i) => new Paragraph({
    shading: { type: ShadingType.CLEAR, fill: 'F2F2F2', color: 'auto' },
    spacing: { after: i === linhas.length - 1 ? 160 : 0 },
    indent: { left: 200, right: 200 },
    border: i === 0 ? { top: { style: BorderStyle.SINGLE, size: 4, color: 'BFBFBF', space: 4 } }
      : i === linhas.length - 1 ? { bottom: { style: BorderStyle.SINGLE, size: 4, color: 'BFBFBF', space: 4 } } : undefined,
    children: [new TextRun({ text: l || ' ', font: 'Consolas', size: 19 })],
  }));
}

function tabela(cabecalho, linhas, larguras) {
  const ws = larguras.map(f => Math.round(f * LARGURA));
  ws[ws.length - 1] = LARGURA - ws.slice(0, -1).reduce((a, b) => a + b, 0);
  const cel = (t, head, w) => new TableCell({
    width: { size: w, type: WidthType.DXA },
    shading: head ? { type: ShadingType.CLEAR, fill: AZUL, color: 'auto' } : undefined,
    margins: { top: 60, bottom: 60, left: 100, right: 100 },
    children: [new Paragraph({ children: head ? [new TextRun({ text: t, bold: true, color: 'FFFFFF' })] : runs(t) })],
  });
  const linha = (cols, head) => new TableRow({
    tableHeader: head,
    children: cols.map((c, i) => cel(c, head, ws[i])),
  });
  return [new Table({
    width: { size: LARGURA, type: WidthType.DXA },
    columnWidths: ws,
    rows: [linha(cabecalho, true), ...linhas.map(l => linha(l, false))],
  }), new Paragraph({ spacing: { after: 120 }, children: [] })];
}

function atencao(titulo, itens) {
  return [
    new Paragraph({
      shading: { type: ShadingType.CLEAR, fill: 'FFF4CE', color: 'auto' },
      border: { left: { style: BorderStyle.SINGLE, size: 24, color: 'E0A800', space: 8 } },
      spacing: { before: 120, after: 0 },
      children: [new TextRun({ text: titulo, bold: true })],
    }),
    ...itens.map((t, i) => new Paragraph({
      shading: { type: ShadingType.CLEAR, fill: 'FFF4CE', color: 'auto' },
      border: { left: { style: BorderStyle.SINGLE, size: 24, color: 'E0A800', space: 8 } },
      spacing: { after: i === itens.length - 1 ? 200 : 0 },
      children: [new TextRun('• '), ...runs(t)],
    })),
  ];
}

// ---------- conteúdo das aulas ----------
const AULAS = [
  () => [
    h1('Aula 01 — Conceitos, CREATE TABLE, INSERT e SELECT'),

    h2('1. O que é um banco de dados relacional'),
    p('É um conjunto de **tabelas** que se relacionam entre si. A vantagem sobre o Excel é que o banco **obriga regras**: a coluna de data só aceita data, a chave nunca se repete e o campo obrigatório não fica vazio.'),
    ...tabela(['Termo', 'No Excel seria...'], [
      ['Tabela', 'Uma aba da planilha'],
      ['Coluna (campo)', 'O cabeçalho da coluna'],
      ['Linha (registro)', 'Uma linha preenchida'],
      ['Chave primária', 'Um código que nunca se repete'],
      ['Schema', 'Uma "pasta" que agrupa tabelas'],
    ], [0.35, 0.65]),

    h2('2. Tipos de dados mais usados (PostgreSQL)'),
    ...tabela(['Tipo', 'Para que serve', 'Exemplo de valor'], [
      ['`INTEGER`', 'Número inteiro', '`42`'],
      ['`NUMERIC(10,2)`', 'Decimal exato — **use para dinheiro** (10 dígitos no total, 2 depois da vírgula)', '`3500.00`'],
      ['`VARCHAR(n)`', 'Texto de até n caracteres', `'Aluguel'`],
      ['`TEXT`', 'Texto sem limite', `'Observação longa...'`],
      ['`DATE`', 'Data no formato AAAA-MM-DD', `'2026-10-05'`],
      ['`BOOLEAN`', 'Verdadeiro / falso', '`TRUE` / `FALSE`'],
      ['`SERIAL`', 'Inteiro numerado sozinho pelo banco (1, 2, 3...)', '(não se informa)'],
    ], [0.25, 0.5, 0.25]),

    h2('3. Schema — organizando por "pastas"'),
    p('Todo banco PostgreSQL já vem com o schema `public`. Para separar os estudos por aula, criamos os nossos schemas e usamos o nome deles antes da tabela, com um ponto.'),
    ...codigo(`CREATE SCHEMA aula01;

CREATE TABLE aula01.categoria ( ... );
SELECT * FROM aula01.categoria;`),

    h2('4. Criar tabela — CREATE TABLE'),
    ...codigo(`CREATE TABLE aula01.membro (
  id_membro   SERIAL PRIMARY KEY,
  nome        VARCHAR(100) NOT NULL,
  data_nasc   DATE,
  renda       NUMERIC(10,2)
);`),
    p('**Restrições** (regras que o banco garante):'),
    bullet('`PRIMARY KEY` — chave primária: identifica a linha e nunca se repete.'),
    bullet('`NOT NULL` — campo obrigatório. `NULL` significa "vazio / desconhecido".'),
    bullet('`DEFAULT valor` — valor usado quando ninguém informa nada. Ex.: `paga BOOLEAN NOT NULL DEFAULT FALSE`.'),

    h2('5. Inserir dados — INSERT INTO'),
    ...codigo(`-- uma linha
INSERT INTO aula01.membro (nome, data_nasc, renda)
VALUES ('Mateus', '1998-05-10', 3500.00);

-- várias linhas de uma vez
INSERT INTO aula01.membro (nome, data_nasc, renda) VALUES
  ('Ana',   '2000-02-20', 4200.50),
  ('Pedro', '2015-08-01', NULL);`),
    bullet('O código `SERIAL` não é informado — o banco preenche sozinho.'),
    bullet('A lista de colunas e a lista de valores precisam ter **a mesma quantidade e a mesma ordem**.'),
    bullet('Coluna com `DEFAULT` pode ficar fora da lista: o banco usa o valor padrão.'),

    h2('6. Consultar — SELECT'),
    ...codigo(`SELECT * FROM aula01.membro;            -- todas as colunas
SELECT nome, renda FROM aula01.membro;  -- só as colunas escolhidas`),

    h2('7. O que o professor acrescenta (Aula 06 dele)'),
    p('**Fases de um projeto de banco de dados:** Projeto **Conceitual** (o que o negócio precisa) → Projeto **Lógico** (tabelas, colunas e relacionamentos) → Projeto **Físico** (os comandos SQL no banco escolhido).'),
    p('**SQL** (Structured Query Language) é a linguagem padrão dos bancos relacionais (padrão ISO desde a década de 80). Ela se divide em grupos:'),
    ...tabela(['Grupo', 'Para quê', 'Comandos'], [
      ['**DDL** — Definição', 'Mexe na **estrutura**', '`CREATE`, `ALTER`, `DROP`'],
      ['**DML** — Manipulação', 'Mexe nos **dados**', '`INSERT`, `UPDATE`, `DELETE`, `SELECT`'],
    ], [0.3, 0.3, 0.4]),
    p('**Texto:** `VARCHAR(n)` tem tamanho variável com limite; `CHAR(n)` tem tamanho **fixo** e completa com espaços em branco; `TEXT` não tem limite.'),
    p('**Data e hora:** `DATE` (só data), `TIME` (só hora), `TIMESTAMP` (data e hora), `INTERVAL` (intervalo de tempo).'),
    p('**Números inteiros:** `SMALLINT` (2 bytes), `INTEGER` (4 bytes), `BIGINT` (8 bytes). `SERIAL` e `BIGSERIAL` são inteiros numerados automaticamente.'),

    ...atencao('Erros mais comuns (olho na prova!)', [
      'Cada coluna do CREATE TABLE termina com vírgula — **menos a última**.',
      'Todo comando termina com `;`.',
      'Texto e data vão entre **aspas simples** `\'...\'`. Número vai sem aspas.',
      'Decimal usa **ponto**, não vírgula: `3500.00`. Escrever `3500,00` vira dois valores separados!',
      'Data é sempre `\'AAAA-MM-DD\'` (ano, mês, dia).',
      'Se o código tem vários erros, o PostgreSQL mostra **só o primeiro**. Corrija e rode de novo.',
      '`--` começa um comentário: o banco ignora o resto da linha.',
      'Cada comando que **altera** o banco (`CREATE`, `ALTER`, `INSERT`, `DROP`) roda **uma vez só**. Repetir dá erro ou duplica dados. `SELECT` pode repetir à vontade.',
    ]),
  ],

  () => [
    h1('Aula 02 — WHERE, ORDER BY, UPDATE e DELETE', true),

    h2('1. WHERE — filtrar linhas'),
    p('O `WHERE` diz **quais linhas** entram no resultado. Só aparecem as linhas em que a condição é verdadeira.'),
    ...codigo(`SELECT nome, escolaridade
FROM funcionario
WHERE escolaridade = 'MESTRE';`),
    ...tabela(['Operador', 'Significa', 'Exemplo'], [
      ['`=`', 'igual', "`escolaridade = 'DOUTOR'`"],
      ['`<>` ou `!=`', 'diferente', "`descricao <> 'PROGRAMADOR'`"],
      ['`>` `<` `>=` `<=`', 'maior, menor, maior ou igual, menor ou igual', '`valor > 2000`'],
      ['`AND`', 'as **duas** condições precisam ser verdadeiras', "`valor > 1000 AND valor < 3000`"],
      ['`OR`', 'basta **uma** ser verdadeira', "`ano = 2004 OR ano = 2005`"],
      ['`IN (...)`', 'igual a qualquer item da lista (atalho para vários OR)', "`escolaridade IN ('MESTRE', 'DOUTOR')`"],
      ['`IS NULL`', 'está vazio (**nunca** use `= NULL`)', '`email IS NULL`'],
    ], [0.22, 0.43, 0.35]),

    h2('2. ORDER BY — ordenar'),
    ...codigo(`SELECT descricao, valor
FROM cargo
ORDER BY valor DESC;           -- DESC = decrescente (maior -> menor)

SELECT nome, escolaridade
FROM funcionario
ORDER BY escolaridade, nome;   -- desempate: escolaridade, depois nome`),
    bullet('`ASC` = crescente (A→Z, menor→maior). É o **padrão**: se não escrever nada, é ASC.'),
    bullet('`DESC` = decrescente (Z→A, maior→menor).'),
    bullet('Com várias colunas, a segunda só serve para **desempatar** a primeira.'),
    p('**Ordem obrigatória das cláusulas:** `SELECT` → `FROM` → `WHERE` → `ORDER BY` (o ORDER BY é sempre o último).'),

    h2('3. UPDATE — alterar dados'),
    ...codigo(`UPDATE cargo
SET valor = 2500
WHERE id_cargo = 1;

-- várias colunas de uma vez: separar por vírgula
UPDATE funcionario
SET nome = 'GERALDO HENRIQUE NETO', escolaridade = 'MESTRE'
WHERE id_funcionario = 1;`),

    h2('4. DELETE — excluir linhas'),
    ...codigo(`DELETE FROM cargo
WHERE id_cargo = 7;

DELETE FROM cargo
WHERE valor > 7000
   OR valor < 100;`),

    ...atencao('A "bomba" do professor', [
      '`UPDATE` ou `DELETE` **sem WHERE** atinge **TODAS as linhas** da tabela.',
      '`UPDATE cargo SET valor = 5000;` → todos os cargos passam a valer 5000.',
      '`DELETE FROM cargo;` → apaga todos os cargos.',
      'Boa prática: antes, rode um **SELECT com o mesmo WHERE** e confira quais linhas serão afetadas.',
      'Filtre pela **chave primária** (`WHERE id = ...`) quando quiser mexer em uma linha só: ela nunca se repete.',
    ]),
  ],
];

// ---------- documento ----------
const doc = new Document({
  creator: 'Mateus Rogério de Souza',
  title: 'Resumo — Banco de Dados',
  styles: {
    default: { document: { run: { font: 'Calibri', size: 22 } } },
    paragraphStyles: [
      { id: 'Heading1', name: 'Heading 1', basedOn: 'Normal', next: 'Normal', quickFormat: true,
        run: { size: 32, bold: true, color: AZUL }, paragraph: { spacing: { before: 240, after: 160 }, outlineLevel: 0 } },
      { id: 'Heading2', name: 'Heading 2', basedOn: 'Normal', next: 'Normal', quickFormat: true,
        run: { size: 26, bold: true, color: '2E75B6' }, paragraph: { spacing: { before: 240, after: 100 }, outlineLevel: 1 } },
    ],
  },
  numbering: { config: [{ reference: 'bolinhas', levels: [{ level: 0, format: LevelFormat.BULLET, text: '•', alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 540, hanging: 270 } } } }] }] },
  features: { updateFields: true },
  sections: [{
    properties: { page: { margin: { top: 1134, bottom: 1134, left: 1440, right: 1440 } } },
    footers: { default: new Footer({ children: [new Paragraph({ alignment: AlignmentType.CENTER, children: [new TextRun({ children: ['Página ', PageNumber.CURRENT], size: 18, color: '808080' })] })] }) },
    children: [
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { before: 600, after: 120 }, children: [new TextRun({ text: 'Resumo para a Prova', bold: true, size: 44, color: AZUL })] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 80 }, children: [new TextRun({ text: 'Banco de Dados — PostgreSQL / Supabase', size: 28 })] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 400 }, children: [new TextRun({ text: 'Mateus Rogério de Souza', italics: true, color: '595959' })] }),
      new Paragraph({ children: [new TextRun({ text: 'Sumário', bold: true, size: 28, color: AZUL })] }),
      new TableOfContents('Sumário', { hyperlink: true, headingStyleRange: '1-2' }),
      new Paragraph({ children: [new PageBreak()] }),
      ...AULAS.flatMap(a => a()),
    ],
  }],
});

const destino = path.join(__dirname, '..', 'Resumo_Banco_de_Dados.docx');
Packer.toBuffer(doc).then(b => { fs.writeFileSync(destino, b); console.log('Gerado:', destino); });
