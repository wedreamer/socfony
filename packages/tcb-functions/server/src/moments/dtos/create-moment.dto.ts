interface CreateMomentBodyDto {
    text: string;
    images?: string[];
    video?: {
        cover: string,
        src: string,
    };
    audio?: {
        src: string,
        cover?: string,
    },
    vote?: string[],
    location?: {
        longitude: number,
        latitude: number,
    },
}

interface CreateMomentDocDto {
    text: string;
    images?: string[];
    video?: {
        cover: string,
        src: string,
    };
    audio?: {
        src: string,
        cover?: string,
    },
    vote?: { name: string }[],
    createdAt: Date,
    userId: string,
    location: any,
}
