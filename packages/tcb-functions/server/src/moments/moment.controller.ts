import { Body, Controller, Post, UsePipes } from "@nestjs/common";
import { JoiValidationPipe } from "src/validator/joi-validation.pipe";
import { CreateMomentValidationSchema } from "./validator/create-moment-validation.schema";

@Controller('moments')
export class MomentController {
    /**
     * Create a moment
     */
    @Post()
    @UsePipes(new JoiValidationPipe(CreateMomentValidationSchema))
    create(@Body() dto) {
        return dto;
    }
}
