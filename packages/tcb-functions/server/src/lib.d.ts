import { UserDto } from "./users/dtos/user.dto";

declare module 'express' {
    interface Request {
        user?: UserDto;
    }
}
