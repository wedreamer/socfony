import { ArgumentMetadata, Injectable, PipeTransform } from "@nestjs/common";
import { UserDto } from "../dtos/user.dto";
import { UserService } from "../user.service";

@Injectable()
export class ParseUserPipe implements PipeTransform<string, Promise<UserDto>> {
    constructor(private readonly userService: UserService) {}

    transform(value: string, metadata: ArgumentMetadata): Promise<UserDto> {
        return this.userService.find(value);
    }
}
