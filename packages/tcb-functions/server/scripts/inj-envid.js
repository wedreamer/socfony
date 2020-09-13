require('dotenv').config();

const code = `export const __CLOUDBASE_ENV_ID__: string = '${process.env.ENV_ID}';`;
const path = require('path').resolve(__dirname, '../src/__cloudbaserc__.ts');

require('fs').writeFileSync(path, code);
