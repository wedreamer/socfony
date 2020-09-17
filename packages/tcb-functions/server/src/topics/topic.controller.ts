import { Body, Controller, HttpCode, HttpStatus, Post, UsePipes } from "@nestjs/common";
import { Auth } from "src/users/auth.decorator";
import { UserDto } from "src/users/dtos/user.dto";
import { JoiValidationPipe } from "src/validator/joi-validation.pipe";
import { TopicDto } from "./dtos/topic.dto";
import { CreateTopicValicationSchema } from "./validator/create-topic-valication.schema";

@Controller('topics')
export class TopicController {
    @Post()
    @HttpCode(HttpStatus.CREATED)
    @UsePipes(new JoiValidationPipe(CreateTopicValicationSchema))
    async create(
        @Auth() user: UserDto,
        @Body() dto: TopicDto,
    ) {
        return dto;
    }
}
