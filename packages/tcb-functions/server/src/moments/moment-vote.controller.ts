import { BadRequestException, Body, Controller, HttpCode, HttpStatus, Param, Put } from "@nestjs/common";
import { CloudBaseService } from "src/cloudbase/cloudbase.service";
import { Auth } from "src/users/auth.decorator";
import { UserDto } from "src/users/dtos/user.dto";
import { MomentDot } from "./dtos/moment.dto";
import { MomentVoteService } from "./moment-vote.service";
import { ParseMomentPipe } from "./pipes/parse-moment.pipe";

@Controller('moments/:id/vote')
export class MomentVoteController {
    constructor(
        protected readonly tcb: CloudBaseService,
        protected readonly service: MomentVoteService,
    ){}

    @Put()
    @HttpCode(HttpStatus.NO_CONTENT)
    async select(
        @Auth() user: UserDto,
        @Param('id', ParseMomentPipe) moment: MomentDot,
        @Body('vote') vote: string,
    ) {
        const hasInclude = (moment.vote ?? []).map(e => e.name).includes(vote);
        if (!hasInclude) {
            throw new BadRequestException('选择的投票内容选项不存在');
        }

        const db = this.tcb.server.database();
        const hasSelectedResult = await db.collection('moment-vote-user-selected')
            .where({
                momentId: moment._id,
                userId: user.uid,
            })
            .count();
        if (hasSelectedResult.total) {
            throw new BadRequestException('当前已存在投票内容，不能连续投票其他内容');
        }

        await this.service.select(user.uid, moment, vote);
    }
}