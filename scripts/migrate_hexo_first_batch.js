const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..');
const sourceDir = path.join(repoRoot, 'hexorepo', 'hexoBlog', 'source', '_posts');
const targetDir = path.join(repoRoot, 'content', 'blog');

const skipFiles = new Set([
  'steamtools.md',
  '2025-09-04-laojunshan.md',
]);

function stripQuotes(value) {
  if (!value) return '';
  const trimmed = value.trim();
  if (
    (trimmed.startsWith('"') && trimmed.endsWith('"')) ||
    (trimmed.startsWith("'") && trimmed.endsWith("'"))
  ) {
    return trimmed.slice(1, -1);
  }
  return trimmed;
}

function parseScalar(value) {
  const trimmed = value.trim();
  if (trimmed === 'true') return true;
  if (trimmed === 'false') return false;
  return stripQuotes(trimmed);
}

function splitCommaList(value) {
  return value
    .split(',')
    .map((item) => stripQuotes(item))
    .map((item) => item.trim())
    .filter(Boolean);
}

function parseInlineArray(value) {
  const inner = value.trim().replace(/^\[/, '').replace(/\]$/, '').trim();
  if (!inner) return [];
  return splitCommaList(inner);
}

function parseFrontMatter(frontMatterText) {
  const lines = frontMatterText.split(/\r?\n/);
  const data = {};

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (!line.trim()) continue;

    const match = line.match(/^([A-Za-z0-9_]+):\s*(.*)$/);
    if (!match) continue;

    const key = match[1];
    const rawValue = match[2] || '';

    if (rawValue === '') {
      const items = [];
      while (i + 1 < lines.length && /^\s*-\s+/.test(lines[i + 1])) {
        i += 1;
        const itemValue = lines[i].replace(/^\s*-\s+/, '').trim();
        if (itemValue.includes(',')) {
          items.push(...splitCommaList(itemValue));
        } else if (itemValue) {
          items.push(stripQuotes(itemValue));
        }
      }
      data[key] = items;
      continue;
    }

    if (rawValue.trim().startsWith('[') && rawValue.trim().endsWith(']')) {
      data[key] = parseInlineArray(rawValue);
      continue;
    }

    if ((key === 'tags' || key === 'categories' || key === 'keywords') && rawValue.includes(',')) {
      data[key] = splitCommaList(rawValue);
      continue;
    }

    data[key] = parseScalar(rawValue);
  }

  return data;
}

function toYamlValue(value) {
  if (typeof value === 'boolean') {
    return value ? 'true' : 'false';
  }
  const text = String(value);
  if (text === '') return "''";
  if (/^[A-Za-z0-9._/-]+$/.test(text)) return text;
  return `'${text.replace(/'/g, "''")}'`;
}

function buildFrontMatter(data) {
  const lines = ['---'];
  const orderedKeys = [
    'title',
    'date',
    'lastmod',
    'draft',
    'description',
    'keywords',
    'author',
    'tags',
    'categories',
    'comments',
  ];

  for (const key of orderedKeys) {
    if (!(key in data)) continue;
    const value = data[key];
    if (Array.isArray(value)) {
      lines.push(`${key}:`);
      for (const item of value) {
        lines.push(`  - ${toYamlValue(item)}`);
      }
      continue;
    }
    lines.push(`${key}: ${toYamlValue(value)}`);
  }

  lines.push('---', '');
  return lines.join('\n');
}

function parseMarkdownFile(fileContent) {
  const match = fileContent.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/);
  if (!match) {
    return null;
  }
  return {
    frontMatter: parseFrontMatter(match[1]),
    body: match[2].replace(/^\r?\n/, ''),
  };
}

function hasHexoShortcode(body) {
  return /\{%\s*[\w-]+[\s\S]*?%\}/.test(body);
}

function migrateFile(fileName) {
  const sourcePath = path.join(sourceDir, fileName);
  const targetPath = path.join(targetDir, fileName);
  const raw = fs.readFileSync(sourcePath, 'utf8');
  const parsed = parseMarkdownFile(raw);

  if (!parsed) {
    return { fileName, status: 'skipped', reason: 'missing front matter' };
  }

  if (hasHexoShortcode(parsed.body)) {
    return { fileName, status: 'skipped', reason: 'contains Hexo shortcode' };
  }

  const fm = parsed.frontMatter;
  const targetFrontMatter = {
    title: fm.title,
    date: fm.date,
    lastmod: fm.updated || fm.lastmod,
    draft: false,
    description: fm.description,
    keywords: fm.keywords,
    author: fm.author,
    tags: Array.isArray(fm.tags) ? fm.tags : [],
    categories: Array.isArray(fm.categories) ? fm.categories : [],
    comments: typeof fm.comments === 'boolean' ? fm.comments : undefined,
  };

  Object.keys(targetFrontMatter).forEach((key) => {
    if (
      targetFrontMatter[key] === undefined ||
      targetFrontMatter[key] === null ||
      (Array.isArray(targetFrontMatter[key]) && targetFrontMatter[key].length === 0)
    ) {
      delete targetFrontMatter[key];
    }
  });

  const finalContent = buildFrontMatter(targetFrontMatter) + parsed.body.trimEnd() + '\n';
  fs.writeFileSync(targetPath, finalContent, 'utf8');
  return { fileName, status: 'migrated', targetPath };
}

fs.mkdirSync(targetDir, { recursive: true });

const files = fs
  .readdirSync(sourceDir)
  .filter((fileName) => fileName.toLowerCase().endsWith('.md'))
  .filter((fileName) => !skipFiles.has(fileName))
  .sort((a, b) => a.localeCompare(b, 'zh-CN'));

const results = [];
for (const fileName of files) {
  results.push(migrateFile(fileName));
}

const migrated = results.filter((item) => item.status === 'migrated');
const skipped = results.filter((item) => item.status === 'skipped');

console.log(`Migrated ${migrated.length} files.`);
for (const item of migrated) {
  console.log(`OK   ${item.fileName}`);
}

if (skipped.length > 0) {
  console.log(`Skipped ${skipped.length} files.`);
  for (const item of skipped) {
    console.log(`SKIP ${item.fileName} (${item.reason})`);
  }
}
