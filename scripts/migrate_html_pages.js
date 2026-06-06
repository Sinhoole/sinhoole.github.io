const fs = require('fs');
const path = require('path');

const src = 'hexorepo/hexoBlog/source';
const dst = '.';

const pages = [
  { srcDir: 'music', title: '音樂' },
  { srcDir: 'photo', title: '攝影集' },
  { srcDir: 'weijing', title: '未镜wJ.TV' },
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
  const body = content.substring(frontEnd + 3).trim();

  const cleanBody = body
    .replace(/\{% btn ['"]?([^'"]+)['"]?,[^%]+\%\}/g, '[$2]($1)')
    .replace(/<a class="btn-beautify larger"[^>]*>([\s\S]*?)<\/a>/g, (match) => {
      const href = match.match(/href="([^"]+)"/);
      const title = match.match(/title="([^"]+)"/);
      return href ? `[${title ? title[1] : '链接'}](${href[1]})` : match;
    });

  const hugoContent = `---
title: '${page.title}'
date: 2025-09-03
draft: false
---

${cleanBody}
`;

  fs.mkdirSync(dstDir, { recursive: true });
  fs.writeFileSync(path.join(dstDir, 'index.md'), hugoContent, 'utf-8');
  console.log('OK', page.srcDir);
}
