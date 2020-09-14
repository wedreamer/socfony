export function setMockTcbFunctionAuthEnv(userId: string): void {
    if (!userId) {
        return;
    }
    const keys = (process.env.TCB_CONTEXT_KEYS || '')
        .split(',')
        .filter(value => value != 'TCB_UUID');
    keys.push('TCB_UUID');
    process.env.TCB_CONTEXT_KEYS = keys.filter(v => !!v).join(',');
    process.env.TCB_UUID = userId;
}

export function removeMockedFunctionAuthEnv() {
    const keys = (process.env.TCB_CONTEXT_KEYS || '').split(',');
    process.env.TCB_CONTEXT_KEYS = keys.filter(value => value != 'TCB_UUID').filter(v => !!v).join(',');
    process.env.TCB_UUID = undefined;
}
