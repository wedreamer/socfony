import { createCloudBaseServer } from "src/utils/cloudbase.util";

export async function TcbDatabaseTopicNotExists(value: string): Promise<string> {
    const db = createCloudBaseServer().database();
    const query = db.collection('topics')
        .where({ 'name': value })
        .count();
    const result = await query;

    if (!!result.total) {
        throw new Error('话题已经存在');
    }

    return value;
}

export async function TcbDatabaseTopicExists(value: string): Promise<string> {
    const db = createCloudBaseServer().database();
    const query = db.collection('topics')
        .where({ 'name': value })
        .count();
    const result = await query;

    if (!result.total) {
        throw new Error('话题不存在');
    }

    return value;
}
