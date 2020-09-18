import { Injectable } from "@nestjs/common";
import { CloudBaseService } from "src/cloudbase/cloudbase.service";
import { TopicDto } from "./dtos/topic.dto";

@Injectable()
export class TopicService {
    constructor(protected readonly tcb: CloudBaseService) {}

    async create(dto: TopicDto): Promise<TopicDto> {
        const db = this.tcb.server.database();
        const result = await db.collection('topics').add(dto);
        dto._id = result.id;

        return dto;
    }
}
