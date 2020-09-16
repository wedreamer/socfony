export class UserDto {
    constructor(
        data?: UserDto,
        public uid: string = data.uid,
        public nickName: string = data.nickName,
        public username: string = data.username,
        public gender: "MALE" | "FEMALE" | "UNKNOWN" = data.gender || "UNKNOWN",
        public country: string = data.country,
        public province: string = data.province,
        public city: string = data.city,
        public avatarUrl: string = data.avatarUrl,
    ) {}
}
