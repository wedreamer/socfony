import { Body, Controller, Post, UsePipes } from "@nestjs/common";
import { CloudBaseService } from "src/cloudbase/cloudbase.service";
import { Auth } from "src/users/auth.decorator";
import { UserDto } from "src/users/dtos/user.dto";
import { JoiValidationPipe } from "src/validator/joi-validation.pipe";
import { MomentService } from "./moment.service";
import { CreateMomentValidationSchema } from "./validator/create-moment-validation.schema";

@Controller('moments')
export class MomentController {
    constructor(
        private readonly tcb: CloudBaseService,
        private readonly service: MomentService,
    ) {}

    get tcbServer() {
        return this.tcb.server;
    }

    /**
     * Create a moment
     */
    @Post()
    @UsePipes(new JoiValidationPipe(CreateMomentValidationSchema))
    async create(
        @Body() dto: CreateMomentBodyDto,
        @Auth() user: UserDto,
    ) {
        const doc = dto as unknown as CreateMomentDocDto;
        if (dto.vote && Array.isArray(dto.vote)) {
            doc.vote = dto.vote.map(value => ({
                name: value,
            }));
        }
        if (dto.location && dto.location.latitude && dto.location.longitude) {
            doc.location = new (this.tcbServer.database()).Geo.Point(dto.location.longitude, dto.location.latitude);
        }

        doc.createdAt = new Date();
        doc.userId = user.uid;

        const docId = await this.service.create(doc);

        return {
            id: docId,
        };
    }
}
