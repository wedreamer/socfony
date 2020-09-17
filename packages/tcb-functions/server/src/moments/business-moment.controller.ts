import { Controller, Get, Param } from "@nestjs/common";
import { CloudBaseService } from "src/cloudbase/cloudbase.service";
import { UserService } from "src/users/user.service";

@Controller('moment-business')
export class BusinessMomentController {
    constructor(
        private readonly tcb: CloudBaseService,
        private readonly userService: UserService,
    ) {}

    @Get('following')
    async following(
        @Param('limit') limit: number = 20,
        @Param('offset') offset: number = 0,
    ) {
        const db = this.tcb.server.database();
        const _ = db.command;
        const user = await this.userService.current();
        
        const query = db.collection('moments')
            .aggregate()
            .lookup({
                from: 'user-follow',
                as: 'follow',
                let: { userId: '$userId' },
                pipeline: _.aggregate.pipeline().match(_.expr(
                    _.aggregate.add([
                        _.aggregate.eq(['$userId', user.uid]),
                        _.aggregate.eq(['$targetUserId', '$$userId']),
                    ]),
                )).project({
                    _id: false,
                    targetUserId: true,
                }).done(),
            })
            .lookup({
                from: 'topic-user',
                as: 'topices',
                let: { topicId: '$topicId' },
                pipeline: _.aggregate.pipeline().match(_.expr(
                    _.aggregate.and([
                        _.aggregate.eq(['$userId', user.uid]),
                        _.aggregate.eq(['$topicId', '$$topicId']),
                    ]),
                )).project({
                    _id: false,
                    topicId: true,
                }).done(),
            })
            .project({
                _id: false,
                id: '$_id',
                createdAt: true,
                userId: true,
                topicId: true,
                follow: _.aggregate.map({
                    input: '$follow',
                    in: '$$this.targetUserId',
                }),
                topices: _.aggregate.map({
                    input: '$topices',
                    in: '$$this.topicId',
                }),
            })
            .match(_.expr(
                _.aggregate.or([
                    _.aggregate.in(['$userId', '$follow']),
                    _.aggregate.in(['$topicId', '$topices']),
                    _.aggregate.eq(['$userId', user.uid]),
                ]),
            ))
            .project({
                id: true,
                createdAt: true,
            })
            .limit(limit)
            .skip(offset)
            .sort({
                createdAt: -1,
            })
            .end();
        
        const result = await query;

        return result.data.map(e => e.id);
    }
}
