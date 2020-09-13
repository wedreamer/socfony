
export class UserDto {
    uid: string;
    nickName: string;
    username?: string;
    gender?: "MALE" | "FEMALE" | "UNKNOWN" = "UNKNOWN";
    country?: string;
    province?: string;
    city?: string;
    avatarUrl?: string;
}
