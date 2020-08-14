const path = require('path');
const fs = require('fs');

const pubspecPath = path.resolve(__dirname, '..', 'pubspec.yaml');
const { version } = require('../package.json');
const contents = fs.readFileSync(pubspecPath).toString();

fs.writeFileSync(pubspecPath, contents.replace(
    /version\:(.*)\#\@cli,Date:(\d+)/,
    'version: ' + version.replace('-', '+') + ' #@cli,Date:' + Date.now(),
));
