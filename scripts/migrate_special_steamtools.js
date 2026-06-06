const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..');
const sourcePath = path.join(repoRoot, 'hexorepo', 'hexoBlog', 'source', '_posts', 'steamtools.md');
const targetPath = path.join(repoRoot, 'content', 'blog', 'steamtools.md');

function splitCommaList(value) {
  return value
    .split(',')
    .map((item) => item.trim())
    .map((item) => item.replace(/^['"]|['"]$/g, ''))
    .filter(Boolean);
}

function parseFrontMatter(text) {
  const match = text.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/);
  if (!match) {
    throw new Error('Invalid front matter');
  }

  const lines = match[1].split(/\r?\n/);
  const data = {};

  for (const line of lines) {
    const m = line.match(/^([A-Za-z0-9_]+):\s*(.*)$/);
    if (!m) continue;
    const key = m[1];
    const raw = m[2].trim();

    if (!raw) {
      data[key] = '';
      continue;
    }

    if (raw.startsWith('[') && raw.endsWith(']')) {
      data[key] = splitCommaList(raw.slice(1, -1));
      continue;
    }

    data[key] = raw.replace(/^['"]|['"]$/g, '');
  }

  return { frontMatter: data, body: match[2] };
}

function yamlScalar(value) {
  if (typeof value === 'boolean') return value ? 'true' : 'false';
  const text = String(value);
  if (text === '') return "''";
  if (/^[A-Za-z0-9._/:+-]+$/.test(text)) return text;
  return `'${text.replace(/'/g, "''")}'`;
}

function buildFrontMatter(source) {
  const lines = ['---'];
  const data = {
    title: source.title,
    date: source.date,
    lastmod: source.updated || source.date,
    draft: false,
    description: source.description,
    keywords: Array.isArray(source.keywords) ? source.keywords : splitCommaList(source.keywords || ''),
    tags: Array.isArray(source.tags) ? source.tags : splitCommaList(source.tags || ''),
    categories: Array.isArray(source.categories) ? source.categories : splitCommaList(source.categories || ''),
    comments: source.comments === 'true',
    ShowToc: source.toc === 'true',
  };

  for (const [key, value] of Object.entries(data)) {
    if (Array.isArray(value)) {
      if (value.length === 0) continue;
      lines.push(`${key}:`);
      for (const item of value) {
        lines.push(`  - ${yamlScalar(item)}`);
      }
      continue;
    }
    if (value === undefined || value === null || value === '') continue;
    lines.push(`${key}: ${yamlScalar(value)}`);
  }

  lines.push('---', '');
  return lines.join('\n');
}

function convertButtons(body) {
  return body.replace(
    /\{%\s*btn\s+'([^']+)'\s*,\s*([^,}]+?)\s*,[\s\S]*?%\}/g,
    (_full, url, label) => `[${label.trim()}](${url.trim()})`
  );
}

const raw = fs.readFileSync(sourcePath, 'utf8');
const { frontMatter, body } = parseFrontMatter(raw);

let newBody = convertButtons(body)
  .replace(/\r\n/g, '\n')
  .replace(/\n{3,}/g, '\n\n')
  .trimEnd() + '\n';

const finalContent = buildFrontMatter(frontMatter) + newBody;
fs.writeFileSync(targetPath, finalContent, 'utf8');
console.log(`Migrated special post to ${targetPath}`);
