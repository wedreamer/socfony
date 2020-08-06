import typescript from 'rollup-plugin-typescript2';
import json from '@rollup/plugin-json';

const external = [
    "@bytegem/cloudbase",
    "@cloudbase/node-sdk/lib/auth"
];

const functionNames = [
    'auth',
    'snsmax-moment',
];

function createFunctionBuilder(name) {
    return {
        input: `cloudbase/functions/${name}/src/main.ts`,
        output: {
            file: `cloudbase/functions/${name}/index.js`,
            format: "cjs"
        },
        plugins: [
            json(),
            typescript({
                tsconfig: "tsconfig.json"
            }),
        ],
        external,
    };
}

export default functionNames.map(createFunctionBuilder);
