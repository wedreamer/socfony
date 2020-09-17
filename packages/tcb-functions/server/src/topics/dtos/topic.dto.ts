export class TopicDto {
    _id: String;
    coratorId: string;
    cover: string;
    createdAt: Date;
    description: string;
    joinType: 'freely' | 'examine'
    name: string;
    title: string;
    postType: 'any' | 'text' | 'image' | 'audio' | 'video';
}
