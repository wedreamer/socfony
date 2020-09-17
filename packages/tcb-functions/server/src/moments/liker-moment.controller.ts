import { Controller, HttpCode, HttpStatus, Param, Put } from "@nestjs/common";
import { CloudBaseService } from "src/cloudbase/cloudbase.service";
import { UserService } from "src/users/user.service";
import { MomentService } from "./moment.service";

@Controller('user/liked/moments')
export class LikerMomentController {
    constructor(
        private readonly userService: UserService,
        private readonly momentService: MomentService,
        private readonly tcb: CloudBaseService,
    ) {}

    @Put(':id')
    @HttpCode(HttpStatus.NO_CONTENT)
    async create(
        @Param('id') id: string,
    ): Promise<undefined | null | void> {
        const user = await this.userService.current();
        const moment = await this.momentService.find(id);

        const db = this.tcb.server.database();
        const hasLikedResult = await db.collection('moment-liked-histories')
            .where({
                userId: user.uid,
                momentId: moment._id,
            })
            .count();
        if (hasLikedResult.total) {
            return null;
        }

        db.runTransaction(async transaction => {
            await transaction.collection('moment-liked-histories')
                .add({
                    userId: user.uid,
                    momentId: moment._id,
                    createdAt: new Date,
                });
            await transaction.collection('moments')
                .doc(moment._id)
                .update({
                    'count.like': db.command.inc(1),
                });
        });
    }
}
