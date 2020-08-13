import path from 'path';
import typescript from 'rollup-plugin-typescript2';

const _p = path.resolve(__dirname, 'cloudbase/functions/app-api');

const resolve = (...args) => path.resolve(_p, ...args);

console.error(_p);

export default {
    input: resolve('src/main.ts'),
    output: {
        file: resolve('index.js'),
        format: 'cjs',
    },
    plugins: [
        typescript({
            tsconfig: 'tsconfig.json',
        })
    ],
    external: ['@cloudbase/node-sdk'],
};
