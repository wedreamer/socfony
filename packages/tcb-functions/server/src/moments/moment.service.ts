import { Injectable } from "@nestjs/common";
import { CloudBaseService } from "src/cloudbase/cloudbase.service";
import { MomentDot } from "./dtos/moment.dto";

@Injectable()
export class MomentService {
    constructor(
        protected readonly tcb: CloudBaseService
    ) {}

    // async find(id: string): Promise<MomentDot> {
    //     const db = this.tcb.server.database();
    //     db.collection('moments').doc(id).get();
    // }
}
