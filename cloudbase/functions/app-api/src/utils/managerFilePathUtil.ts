export function getCloudFilePath(cloudFileId: string): string {
    if (cloudFileId.match('cloud://*') == null) {
        throw new Error('文件id不合法');
    }

    return cloudFileId.replace(/cloud:\/\/[a-zA-z0-9\.\-\_]+\//, '');
}
