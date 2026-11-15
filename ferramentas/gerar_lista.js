// Gera "Lista_Exercicios_Prova.docx" (enunciados). Gabarito: lista/gabarito.sql
const fs = require('fs');
const path = require('path');
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, HeadingLevel,
  AlignmentType, WidthType, ShadingType, BorderStyle, LevelFormat, Footer, PageNumber,
} = require('docx');

const AZUL = '1F4E79';
const LARGURA = 9026;

function runs(texto) {
  return texto.split(/(\*\*[^*]+\*\*|`[^`]+`)/g).filter(Boolean).map(t => {
    if (t.startsWith('**')) return new TextRun({ text: t.slice(2, -2), bold: true });
    if (t.startsWith('`')) return new TextRun({ text: t.slice(1, -1), font: 'Consolas', color: 'A31515' });
    return new TextRun(t);
  });
}
const p = (t, o = {}) => new Paragraph({ spacing: { after: 120 }, children: runs(t), ...o });
const h1 = (t, nova) => new Paragraph({ heading: HeadingLevel.HEADING_1, pageBreakBefore: !!nova, children: [new TextRun(t)] });
const h2 = t => new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun(t)] });
const bullet = t => new Paragraph({ numbering: { reference: 'bol', level: 0 }, spacing: { after: 60 }, children: runs(t) });

let n = 0;
// questão numerada + linha "esperado" em cinza + espaço para resposta
function q(texto, esperado, linhasResp = 3) {
  n++;
  const out = [new Paragraph({ spacing: { before: 160, after: 60 }, keepNext: true,
    children: [new TextRun({ text: `${n}. `, bold: true, color: AZUL }), ...runs(texto)] })];
  if (esperado) out.push(new Paragraph({ spacing: { after: 60 }, indent: { left: 300 }, keepNext: true,
    children: [new TextRun({ text: 'Confira: ' + esperado, italics: true, size: 19, color: '7F7F7F' })] }));
  for (let i = 0; i < Math.min(linhasResp, 2); i++) out.push(new Paragraph({ indent: { left: 300 }, spacing: { after: 0 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 4, color: 'D9D9D9', space: 6 } }, children: [new TextRun(' ')] }));
  return out;
}
function codigo(texto) {
  const ls = texto.trim().split('\n');
  return ls.map((l, i) => new Paragraph({
    shading: { type: ShadingType.CLEAR, fill: 'F2F2F2', color: 'auto' }, indent: { left: 300, right: 200 },
    spacing: { after: i === ls.length - 1 ? 120 : 0 },
    children: [new TextRun({ text: l || ' ', font: 'Consolas', size: 19 })] }));
}
function tabela(cab, linhas, larg) {
  const ws = larg.map(f => Math.round(f * LARGURA)); ws[ws.length - 1] = LARGURA - ws.slice(0, -1).reduce((a, b) => a + b, 0);
  const cel = (t, head, w) => new TableCell({ width: { size: w, type: WidthType.DXA },
    shading: head ? { type: ShadingType.CLEAR, fill: AZUL, color: 'auto' } : undefined,
    margins: { top: 40, bottom: 40, left: 90, right: 90 },
    children: [new Paragraph({ children: head ? [new TextRun({ text: t, bold: true, color: 'FFFFFF', size: 19 })] : [new TextRun({ text: t, size: 19 })] })] });
  return [new Table({ width: { size: LARGURA, type: WidthType.DXA }, columnWidths: ws,
    rows: [new TableRow({ tableHeader: true, children: cab.map((c, i) => cel(c, true, ws[i])) }),
      ...linhas.map(l => new TableRow({ children: l.map((c, i) => cel(c, false, ws[i])) }))] }),
    new Paragraph({ spacing: { after: 100 }, children: [] })];
}

const corpo = [
  new Paragraph({ alignment: AlignmentType.CENTER, spacing: { before: 200, after: 80 }, children: [new TextRun({ text: 'Lista de Exercícios para a Prova', bold: true, size: 40, color: AZUL })] }),
  new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 60 }, children: [new TextRun({ text: 'Banco de Dados — PostgreSQL · Prova em 19/11/2026', size: 24 })] }),
  new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 300 }, children: [new TextRun({ text: 'Mateus Rogério de Souza', italics: true, color: '595959' })] }),

  h2('Como usar'),
  bullet('Tema: uma **clínica médica** (especialidades, médicos, pacientes e consultas). Tudo novo, para treinar sem "decorar" os exercícios anteriores.'),
  bullet('No Supabase, use o schema **`lista`**. Coloque `SET search_path TO lista;` no topo de cada bloco.'),
  bullet('**Faça na ordem**: as partes dependem umas das outras (a Parte F usa os dados já alterados na Parte D).'),
  bullet('Antes de rodar cada SELECT, **preveja** quantas linhas vão aparecer. A linha "Confira" diz o resultado certo.'),
  bullet('Gabarito comentado no GitHub: `lista/gabarito.sql`. **Só abra depois de tentar!**'),
  bullet('⭐ = tipo de questão que mais cai / onde você mais errou nos exercícios.'),

  h2('O modelo'),
  ...tabela(['Tabela', 'Colunas', 'Ligações'], [
    ['ESPECIALIDADE', 'id_especialidade (PK), nome', '—'],
    ['MEDICO', 'id_medico (PK), nome, crm, id_especialidade, valor_consulta', 'id_especialidade → ESPECIALIDADE'],
    ['PACIENTE', 'id_paciente (PK), nome, cidade, ano_nascimento', '—'],
    ['CONSULTA', 'id_consulta (PK), id_medico, id_paciente, data_consulta, valor, pago', 'id_medico → MEDICO · id_paciente → PACIENTE'],
  ], [0.2, 0.47, 0.33]),
  p('A **CONSULTA** liga médico e paciente (um paciente consulta vários médicos e um médico atende vários pacientes) — o mesmo papel da MATRICULA entre aluno e curso.'),

  h1('Parte A — Estrutura (CREATE)', true),
  ...q('Escreva o comando que você usaria **na prova** para criar o banco **"CLINICA"** com template **template0** e codificação **WIN1252**. Depois crie no Supabase o schema `lista`.', null, 3),
  ...q('Crie a sequence **`seq_especialidade`** (incremento 1, mínimo 1) e a tabela **ESPECIALIDADE**: `id_especialidade` INTEGER numerado pela sequence; `nome` texto até 40, obrigatório. Restrições **nomeadas**: `pk_especialidade` (chave primária) e `uq_especialidade_nome` (nome não repete).', null, 7),
  ...q('Crie a tabela **MEDICO**: `id_medico` SERIAL; `nome` texto até 60, obrigatório; `crm` texto até 10, obrigatório e **único** (`uq_medico_crm`); `id_especialidade` INTEGER **opcional**, chave estrangeira para ESPECIALIDADE (`fk_medico_especialidade`); `valor_consulta` dinheiro, obrigatório. Chave primária `pk_medico`. ⭐', null, 9),
  ...q('Crie a tabela **PACIENTE**: `id_paciente` SERIAL chave primária; `nome` texto até 60; `cidade` texto até 40; `ano_nascimento` inteiro — **todos obrigatórios**.', null, 6),
  ...q('Crie a tabela **CONSULTA**: `id_consulta` SERIAL (PK); `id_medico` e `id_paciente` INTEGER obrigatórios, cada um com chave estrangeira; `data_consulta` data obrigatória; `valor` dinheiro obrigatório; `pago` verdadeiro/falso, obrigatório, padrão **falso**. ⭐', null, 9),
  ...q('(teoria) Em que **ordem** as 4 tabelas precisam ser criadas? **Por quê?**', null, 3),

  h1('Parte B — Inserir (INSERT)', true),
  ...q('Insira as especialidades: **Cardiologia, Pediatria, Ortopedia, Dermatologia** (nessa ordem, para ficarem com os códigos 1 a 4).', 'SELECT * mostra 4 linhas, códigos 1 a 4.', 3),
  p('**Dados para a questão 8** (valores e datas no formato brasileiro — converta!):'),
  ...tabela(['Nome', 'CRM', 'Especialidade', 'Valor da consulta'], [
    ['Dr. Paulo Mendes', '1001', '1 (Cardiologia)', 'R$ 350,00'],
    ['Dra. Carla Reis', '1002', '2 (Pediatria)', 'R$ 280,00'],
    ['Dr. Rafael Lima', '1003', '1 (Cardiologia)', 'R$ 400,00'],
    ['Dra. Beatriz Nogueira', '1004', '3 (Ortopedia)', 'R$ 320,00'],
    ['Dr. Otávio Prado', '1005', '(não informada)', 'R$ 250,00'],
  ], [0.34, 0.14, 0.28, 0.24]),
  ...q('Insira os 5 médicos da tabela acima. O Dr. Otávio **não tem especialidade** informada.', '5 médicos, códigos 1 a 5; o Otávio com id_especialidade vazio (NULL).', 5),
  p('**Dados para a questão 9:**'),
  ...tabela(['Nome', 'Cidade', 'Ano de nascimento'], [
    ['Marcos Antunes', 'Franca', '1980'], ['Juliana Freitas', 'Ribeirão Preto', '1992'],
    ['Pedro Henrique Silva', 'Franca', '2015'], ['Luana Castro', 'Batatais', '1975'], ['Roberto Dias', 'Franca', '1960'],
  ], [0.45, 0.3, 0.25]),
  ...q('Insira os 5 pacientes.', '5 pacientes, códigos 1 a 5.', 4),
  p('**Dados para a questão 10:**'),
  ...tabela(['Médico', 'Paciente', 'Data', 'Valor', 'Pago?'], [
    ['1 (Paulo)', '1 (Marcos)', '03/11/2026', '350,00', 'sim'],
    ['2 (Carla)', '3 (Pedro)', '04/11/2026', '280,00', 'sim'],
    ['3 (Rafael)', '2 (Juliana)', '05/11/2026', '400,00', 'sim'],
    ['1 (Paulo)', '4 (Luana)', '05/11/2026', '350,00', '(não informar)'],
    ['5 (Otávio)', '1 (Marcos)', '10/11/2026', '250,00', '(não informar)'],
    ['2 (Carla)', '3 (Pedro)', '12/11/2026', '280,00', '(não informar)'],
    ['3 (Rafael)', '4 (Luana)', '12/11/2026', '400,00', '(não informar)'],
  ], [0.2, 0.22, 0.2, 0.15, 0.23]),
  ...q('Insira as 7 consultas, **na ordem da tabela** (códigos 1 a 7). Use dois INSERTs: um para as pagas e outro para as que deixam o banco usar o padrão. ⭐', '7 consultas; só as 3 primeiras com pago = true.', 6),
  ...q('Tente inserir uma consulta do médico **99** para o paciente 1 em 15/11/2026, valor 300,00. O que acontece? **Por quê?**', 'dá erro de chave estrangeira — leia o nome da restrição na mensagem.', 3),
  ...q('Tente inserir o médico "Dr. Teste", CRM **1001**, valor 100,00. O que acontece? **Por quê?**', 'dá erro — qual restrição foi quebrada?', 3),

  h1('Parte C — Consultas (SELECT, WHERE, ORDER BY)', true),
  ...q('Nome dos pacientes de **Franca**, em ordem alfabética.', '3 linhas (Marcos, Pedro Henrique, Roberto).', 3),
  ...q('Nome e valor da consulta dos médicos que cobram **mais de 300,00**, do maior para o menor valor. ⭐', '3 linhas, começa no Dr. Rafael (400).', 3),
  ...q('Código, data e valor das consultas **não pagas**, da mais antiga para a mais nova. ⭐', '4 linhas (consultas 4, 5, 6, 7).', 3),
  ...q('Nome e ano de nascimento dos pacientes nascidos **antes de 1980** ou **depois de 2010**, do mais novo para o mais velho.', '3 linhas: Pedro Henrique, Luana, Roberto.', 4),
  ...q('Código e data das consultas **de 04/11/2026 a 10/11/2026** (incluindo os dois dias), ordenadas pela data.', '4 linhas (consultas 2, 3, 4, 5).', 4),
  ...q('Nome dos médicos **sem especialidade** informada. ⭐', '1 linha: Dr. Otávio Prado.', 2),
  ...q('Nome e cidade dos pacientes de **Franca ou Batatais** (use `IN`), ordenados por cidade e, dentro dela, por nome.', '4 linhas, começa em Luana (Batatais).', 4),

  h1('Parte D — Alterar e excluir (UPDATE, DELETE)', true),
  p('Lembre: **antes** de cada UPDATE/DELETE, faça um SELECT com o mesmo WHERE para conferir.'),
  ...q('A consulta da **Luana em 05/11/2026** foi paga. Atualize. (Descubra o código dela antes.)', 'só essa consulta muda; as outras ficam iguais.', 3),
  ...q('A **Dra. Carla** passou a cobrar **300,00** pela consulta. Atualize o cadastro dela. Depois responda: o valor das consultas que ela **já fez** mudou? Por quê?', 'medico 2 com 300.00; as consultas 2 e 6 continuam 280.00.', 4),
  ...q('A consulta **7** (Rafael/Luana em 12/11) foi cancelada. Exclua.', 'a tabela consulta fica com 6 linhas.', 2),
  ...q('(sem rodar!) O que aconteceria com `UPDATE consulta SET pago = TRUE;`? ⭐', null, 2),

  h1('Parte E — Alterar a estrutura (ALTER TABLE)', true),
  ...q('Acrescente a coluna `telefone` (texto até 15) na tabela PACIENTE.', null, 2),
  ...q('Acrescente a coluna `ativo` (verdadeiro/falso, **obrigatória**, padrão verdadeiro) na tabela MEDICO. Por que esse comando funciona, mesmo a tabela já tendo dados?', 'os 5 médicos ficam com ativo = true.', 3),
  ...q('Remova a coluna `telefone` da tabela PACIENTE.', null, 2),
  ...q('Tente excluir o paciente **Marcos** (código 1). O que acontece? Por quê? Como seria possível excluí-lo?', 'dá erro de chave estrangeira.', 3),

  h1('Parte F — JOINs ⭐⭐⭐', true),
  p('Estado dos dados aqui: 6 consultas (a 7 foi excluída) e a consulta 4 já paga.'),
  ...q('Data da consulta, **nome do paciente** e valor de todas as consultas, ordenadas pela data.', '6 linhas.', 5),
  ...q('Nome do médico e **nome da especialidade** (INNER JOIN). Quantas linhas vieram? **Quem sumiu e por quê?**', '4 linhas.', 5),
  ...q('Todos os médicos com o nome da especialidade, **inclusive quem não tem especialidade**. Ordene pelo nome do médico.', '5 linhas; Otávio com especialidade vazia.', 5),
  ...q('Todas as **especialidades** com seus médicos, **inclusive especialidade sem médico**, usando **RIGHT JOIN** (medico no FROM).', '5 linhas; Dermatologia com médico vazio.', 5),
  ...q('Médicos e especialidades com **FULL JOIN**. Explique as duas linhas que têm um lado vazio.', '6 linhas.', 5),
  ...q('**3 tabelas:** data, nome do médico, nome do paciente e valor de todas as consultas, por data. Quem aparece 2 vezes como paciente, e por quê?', '6 linhas; Marcos e Pedro Henrique aparecem 2x.', 6),
  ...q('Pacientes que **nunca** fizeram consulta.', '1 linha: Roberto Dias.', 5),
  ...q('Médicos que **não atenderam** nenhuma consulta.', '1 linha: Dra. Beatriz Nogueira.', 5),
  ...q('**Desafio (4 tabelas):** data, paciente, médico e **especialidade** de **todas** as consultas. Atenção: a consulta do Dr. Otávio não pode sumir!', '6 linhas; a do Otávio com especialidade vazia. Qual JOIN precisa ser LEFT?', 7),
  ...q('Data, paciente, médico e valor das consultas **não pagas** de pacientes de **Franca**, por data.', '2 linhas (10/11 e 12/11).', 6),

  h1('Parte G — Caça aos erros', true),
  ...q('Encontre os **4 erros** (um deles não dá mensagem de erro!) e reescreva:', null, 0),
  ...codigo(`SELECT nome cidade FROM paciente
WHERE cidade = "Franca" OR 'Batatais'
ORDER BY DESC;`),
  ...q('Encontre os **3 erros** e reescreva (depois rode, criando a tabela EXAME):', null, 0),
  ...codigo(`CREATE TABLE exame (
  id_exame SERIAL PRIMARY KEY
  id_consulta INTEGER NOT NULL,
  descricao VARCHAR(60) NOT NULL,
  FOREIGN KEY (id_consulta) REFERENCES consultas (id_consulta),
);`),
  ...q('A intenção era listar paciente e médico das consultas **não pagas**. Encontre os **3 problemas** e reescreva:', 'versão certa: 2 linhas.', 0),
  ...codigo(`SELECT p.nome, m.nome
FROM paciente p
JOIN medico m ON (m.id_medico = c.id_medico)
JOIN consulta c ON (c.id_paciente = p.id_paciente)
WHERE c.pago = NULL;`),
];

const doc = new Document({
  creator: 'Mateus Rogério de Souza', title: 'Lista de Exercícios para a Prova',
  styles: {
    default: { document: { run: { font: 'Calibri', size: 22 } } },
    paragraphStyles: [
      { id: 'Heading1', name: 'Heading 1', basedOn: 'Normal', next: 'Normal', quickFormat: true, run: { size: 30, bold: true, color: AZUL }, paragraph: { spacing: { before: 120, after: 160 }, outlineLevel: 0 } },
      { id: 'Heading2', name: 'Heading 2', basedOn: 'Normal', next: 'Normal', quickFormat: true, run: { size: 26, bold: true, color: '2E75B6' }, paragraph: { spacing: { before: 200, after: 100 }, outlineLevel: 1 } },
    ],
  },
  numbering: { config: [{ reference: 'bol', levels: [{ level: 0, format: LevelFormat.BULLET, text: '•', alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 540, hanging: 270 } } } }] }] },
  sections: [{
    properties: { page: { margin: { top: 1134, bottom: 1134, left: 1440, right: 1440 } } },
    footers: { default: new Footer({ children: [new Paragraph({ alignment: AlignmentType.CENTER, children: [new TextRun({ children: ['Página ', PageNumber.CURRENT], size: 18, color: '808080' })] })] }) },
    children: corpo,
  }],
});
const destino = path.join(__dirname, '..', 'Lista_Exercicios_Prova.docx');
Packer.toBuffer(doc).then(b => { fs.writeFileSync(destino, b); console.log('Gerado:', destino, '-', n, 'questões'); });
