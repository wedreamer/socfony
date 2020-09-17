import { Controller, Delete, HttpCode, HttpStatus, Param, Put } from "@nestjs/common";
import { CloudBaseService } from "src/cloudbase/cloudbase.service";
import { Auth } from "src/users/auth.decorator";
import { UserDto } from "src/users/dtos/user.dto";
import { MomentDot } from "./dtos/moment.dto";
import { ParseMomentPipe } from "./pipes/parse-moment.pipe";

@Controller('user/liked/moments')
export class LikerMomentController {
    constructor(
        private readonly tcb: CloudBaseService,
    ) {}

    @Put(':id')
    @HttpCode(HttpStatus.NO_CONTENT)
    async create(
        @Auth() user: UserDto,
        @Param('id', ParseMomentPipe) moment: MomentDot,
    ): Promise<undefined | null | void> {
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

    @Delete(':id')
    @HttpCode(HttpStatus.NO_CONTENT)
    async destroy(
        @Param('id') id: string,
        @Auth() user: UserDto,
    ): Promise<void> {
        const db = this.tcb.server.database();
        const hasLikedResult = await db.collection('moment-liked-histories')
            .where({
                userId: user.uid,
                momentId: id,
            })
            .count();
        if (!hasLikedResult.total) {
            return null;
        }

        db.runTransaction(async transaction => {
            await transaction.collection('moment-liked-histories')
                .where({
                    momentId: id,
                    userId: user.uid,
                })
                .remove();
            await transaction.collection('moments')
                .doc(id)
                .update({
                    'count.like': db.command.inc(-1),
                })
        });
    }
}
