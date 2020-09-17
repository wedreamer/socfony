import { ArgumentMetadata, Injectable, PipeTransform } from "@nestjs/common";
import { MomentDot } from "../dtos/moment.dto";
import { MomentService } from "../moment.service";

@Injectable()
export class ParseMomentPipe implements PipeTransform<string, Promise<MomentDot>> {
    constructor(private readonly momentService: MomentService) {}
    transform(value: string, metadata: ArgumentMetadata): Promise<MomentDot> {
        return this.momentService.find(value);
    }
}
