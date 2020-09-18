import { Injectable } from "@nestjs/common";
import { CloudBaseService } from "src/cloudbase/cloudbase.service";
import { MomentDot } from "./dtos/moment.dto";

@Injectable()
export class MomentVoteService {
    constructor(
        protected readonly tcb: CloudBaseService,
    ){}

    async select(userId: string, moment: MomentDot, vote: string) {
        const db = this.tcb.server.database();

        const index = moment.vote.map(e => e.name).indexOf(vote);
        
        return await db.runTransaction(async transaction => {
            await transaction.collection('moment-vote-user-selected').add({
                momentId: moment._id,
                userId,
                vote,
                createdAt: new Date,
            });
            await transaction.collection('moments').doc(moment._id).update({
                [`vote.${index}.count`]: db.command.inc(1),
            });
        });
    }
}
