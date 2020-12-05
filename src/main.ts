import { Logger } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";

/**
 * Create application bootstrap.
 */
async function bootstrap() {
    // create application
    const app = await NestFactory.create(AppModule);

    // get IoC logger
    const logger = app.get(Logger);

    // set app use logger
    app.useLogger(logger);

    await app.listen(3000);

    logger.log(`Application listening http://127.0.0.1:3000`, "Bootstrap");
}

// Application run.
bootstrap();
