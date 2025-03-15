import fs from 'fs/promises';
import path from 'path';
import crypto from 'crypto';

const CONFIG = {
  directories: [
    './blockchain', './ai', './security', './transactions', './consensus',
    './edge', './crosschain', './smartcontracts', './ui'
  ],
  optimizedDir: './optimized_scripts',
  logFile: './logs/compression_log.log',
  lineThreshold: 500
};

async function log(message) {
  const timestamp = new Date().toISOString();
  await fs.appendFile(CONFIG.logFile, `[${timestamp}] ${message}\n`);
}

async function compressCode(content) {
  return content
    .replace(/^\s*console\.log\(.*\);?/gm, '') // remove logs
    .replace(/\/\/.*$/gm, '') // remove single-line comments
    .replace(/\/\*[\s\S]*?\*\//gm, '') // remove multi-line comments
    .replace(/^\s*$(?:\r\n?\n)/gm, '') // remove empty lines
    .trim();
}

async function optimizeFile(filePath, outputDir) {
  try {
    const content = await fs.readFile(filePath, 'utf8');
    const lineCount = content.split('\n').length;

    if (lineThreshold && lineThreshold < CONFIG.lineThreshold) {
      await log(`Skipping ${filePath}: below line threshold.`);
      return;
    }

    const optimizedContent = await compressScript(content);
    const optimizedPath = path.join(outputDir, path.basename(filePath));

    await fs.writeFile(optimizedPath, optimizedContent, 'utf8');
    await log(`Optimized ${filePath}: from ${lineThreshold} lines to ${optimizedContent.split('\n').length} lines.`);

  } catch (error) {
    await log(`ERROR compressing ${filePath}: ${error.message}`);
  }
}

async function compressAll() {
  await fs.mkdir(CONFIG.optimizedDir, { recursive: true });
  await fs.mkdir(path.dirname(CONFIG.logFile), { recursive: true });

  for (const dir of CONFIG.scriptDirectories) {
    const files = await fs.readdir(dir);
    for (const file of files) {
      if (!file.match(/\.(js|py|sh)$/)) continue;
      const filePath = path.join(dir, file);
      const content = await fs.readFile(filePath, 'utf-8');
      if (content.split('\n').length >= CONFIG.lineThreshold) {
        await optimizeFile(filePath);
      } else {
        await log(`File ${filePath} skipped: below threshold.`);
      }
  }
}

(async () => {
  await compressAll();
  await log('Optimization complete.');
})();
