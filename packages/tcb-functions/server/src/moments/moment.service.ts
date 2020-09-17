import { Injectable, NotFoundException } from "@nestjs/common";
import { CloudBaseService } from "src/cloudbase/cloudbase.service";
import { MomentDot } from "./dtos/moment.dto";

@Injectable()
export class MomentService {
    constructor(
        protected readonly tcb: CloudBaseService
    ) {}

    get tcbServer() {
        return this.tcb.server
    }

    async create(dto: CreateMomentDocDto): Promise<string> {
        const db = this.tcbServer.database();
        const result = await db.collection('moments').add(dto);

        return result.id;
    }

    async find(id: string): Promise<MomentDot> {
        const db = this.tcb.server.database();
        const moment = await db.collection('moments').doc(id).get();
        
        if (moment.code || !moment.data || (Array.isArray(moment.data) && moment.data.length <= 0)) {
            throw new NotFoundException(moment.message);
        }

        return moment.data.pop();
    }
}
