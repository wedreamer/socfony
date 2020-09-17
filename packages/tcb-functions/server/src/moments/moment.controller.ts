import { Body, Controller, Post, UsePipes } from "@nestjs/common";
import { CloudBaseService } from "src/cloudbase/cloudbase.service";
import { UserService } from "src/users/user.service";
import { JoiValidationPipe } from "src/validator/joi-validation.pipe";
import { MomentService } from "./moment.service";
import { CreateMomentValidationSchema } from "./validator/create-moment-validation.schema";

@Controller('moments')
export class MomentController {
    constructor(
        private readonly tcb: CloudBaseService,
        private readonly userService: UserService,
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
    async create(@Body() dto: CreateMomentBodyDto) {
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
        doc.userId = (await this.userService.current()).uid;

        const docId = await this.service.create(doc);

        return {
            id: docId,
        };
    }
}
