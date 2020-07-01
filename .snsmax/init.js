const fs = require('fs');
const path = require('path');

const templatePath = path.resolve(__dirname, 'template', 'config.yaml');
const outputPath = path.resolve(__dirname, '..', '.snsmax.yaml');

if (!fs.existsSync(outputPath)) {
    fs.writeFileSync(outputPath, fs.readFileSync(templatePath));
}

console.log(`[√] created snsmax config file to [${outputPath}]`);
