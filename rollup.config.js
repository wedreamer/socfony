import typescript from 'rollup-plugin-typescript2';
import json from 'rollup-plugin-json';

export default {
    input: "cloudbase/functions/moment/src/main.ts",
    output: {
        file: "cloudbase/functions/moment/index.js",
        format: "cjs"
    },
    plugins: [
        json(),
        typescript({
            tsconfig: "tsconfig.json"
        }),
    ],
    external: ["@bytegem/cloudbase"],
};
