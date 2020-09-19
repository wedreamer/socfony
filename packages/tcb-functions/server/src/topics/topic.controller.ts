import { Body, Controller, HttpCode, HttpStatus, Post, UsePipes } from "@nestjs/common";
import { Auth } from "src/users/auth.decorator";
import { UserDto } from "src/users/dtos/user.dto";
import { JoiValidationPipe } from "src/validator/joi-validation.pipe";
import { TopicDto } from "./dtos/topic.dto";
import { TopicService } from "./topic.service";
import { CreateTopicValicationSchema } from "./validator/create-topic-valication.schema";

@Controller('topics')
export class TopicController {
    constructor(protected readonly service: TopicService) {}

    @Post()
    @HttpCode(HttpStatus.CREATED)
    async create(
        @Auth() user: UserDto,
        @Body(new JoiValidationPipe(CreateTopicValicationSchema)) dto: TopicDto,
    ) {
        dto.coratorId = user.uid;
        dto.createdAt = new Date;
        
        const topic = await this.service.create(dto);

        return { id: topic._id };
    }
}
