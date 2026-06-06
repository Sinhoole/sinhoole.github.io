const fs = require('fs');
const path = require('path');

const src = 'hexorepo/hexoBlog/source';
const dst = '.';

const pages = [
  { srcDir: 'about', title: 'Ta0X1 | 一年写' },
  { srcDir: 'tour', title: '丙戌十九年' },
  { srcDir: 'financial-report', title: 'Financial Report' },
];

for (const page of pages) {
  const srcFile = path.join(src, page.srcDir, 'index.md');
  const dstDir = path.join(dst, 'content', page.srcDir);

  if (!fs.existsSync(srcFile)) {
    console.log('SKIP', srcFile, '(not found)');
    continue;
  }

  let content = fs.readFileSync(srcFile, 'utf-8');

  const frontEnd = content.indexOf('---', 3);
  const rawFm = content.substring(4, frontEnd).trim();

  const dateMatch = rawFm.match(/^date:\s*(.+)$/m);
  const date = dateMatch ? dateMatch[1].trim() : new Date().toISOString().split('T')[0];

  const body = content.substring(frontEnd + 3).trim();

  const hugoContent = `---
title: '${page.title}'
date: ${date}
draft: false
---

${body}
`;

  fs.mkdirSync(dstDir, { recursive: true });
  fs.writeFileSync(path.join(dstDir, 'index.md'), hugoContent, 'utf-8');
  console.log('OK', page.srcDir);
}
