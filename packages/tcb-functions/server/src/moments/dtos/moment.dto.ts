export class MomentDot {
    _id: string;
    userId: string;
    text: string;
    audio?: {
        cover?: string;
        src: string;
    };
    images?: string[];
    video?: {
        cover: string;
        src: string;
    };
    location: {
        type: "Point";
        coordinates: [number, number];
    };
    createdAt: string;
    count: {
        like?: number;
        comment?: number;
    };
    topicId?: string;
    vote?: {
        name: string;
        count?: number;
    }[]
}