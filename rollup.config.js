import typescript from 'rollup-plugin-typescript2';
import json from 'rollup-plugin-json';

export default {
    input: "cloudbase/functions/snsmax-moment/src/main.ts",
    output: {
        file: "cloudbase/functions/snsmax-moment/index.js",
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
