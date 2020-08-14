import path from 'path';
import typescript from 'rollup-plugin-typescript2';

const resolve = (...args) => path.resolve(__dirname, ...args);

const pkg = require(resolve('package.json'));

export default {
    input: resolve('src/main.ts'),
    output: {
        file: resolve('index.js'),
        format: 'cjs',
    },
    plugins: [
        typescript({
            tsconfig: resolve('tsconfig.json'),
        })
    ],
    external: Object.keys(pkg.dependencies),
};
