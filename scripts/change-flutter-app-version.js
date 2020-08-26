const path = require('path');
const fs = require('fs');

const pubspecPath = path.resolve(__dirname, '..', 'pubspec.yaml');
const contents = fs.readFileSync(pubspecPath).toString();
const patten = /^(\d{1,2}.\d{1,2}).(\d{1,2})$/;
const version = process.argv[2];

const [_, v1, v2] = patten.exec(version);


fs.writeFileSync(pubspecPath, contents.replace(
    /version\:(.*)\#\@cli,Date:(\d+)/,
    'version: ' + v1 + '+' + v2 + ' #@cli,Date:' + Date.now(),
));
