import { Controller, Get } from "@nestjs/common";
import { PrismaService } from "src";

@Controller()
export class AppController {
    constructor(
        private readonly prisma: PrismaService,
    ) {}

    @Get()
    async get() {
        const publisher = await this.prisma.user.findOne({
            where: {
                id: "5cdff3f9-a2b6-49e4-830f-1f5d92f54b62"
            }
        })
        const hah = await this.prisma.moment.create({
            data: {
                publisher: {
                    connect: {
                        id: publisher.id,
                    },
                },
            },
        })
        const demo = await this.prisma.moment.findMany({
            cursor: {
                id: "ff383886-e086-4a71-96da-b18141590e7c"
            },
            take: 1,
            skip: 1,
            orderBy: {
                id: "desc"
            },
            select: {
                id: true,
            }
        });

        // console.log(demo.moments.length, hah);

        return demo;
    }
}