const fs = require('fs');
const path = require('path');

const blogDir = path.join(__dirname, '..', 'content', 'blog');

function trimTitleValue(title) {
  return title.replace(/\s+[-－—]\s+.*$/, '').trim();
}

for (const fileName of fs.readdirSync(blogDir)) {
  if (!fileName.endsWith('.md')) continue;

  const filePath = path.join(blogDir, fileName);
  const original = fs.readFileSync(filePath, 'utf8');
  const updated = original.replace(
    /^title:\s*(['"])(.+?)\1/m,
    (full, quote, title) => `title: ${quote}${trimTitleValue(title)}${quote}`
  );

  if (updated !== original) {
    fs.writeFileSync(filePath, updated, 'utf8');
    console.log(`Updated ${fileName}`);
  }
}
