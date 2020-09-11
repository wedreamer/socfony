import { createApp } from "./app";

const bootstrap = async () => {
    const app = await createApp();
    app.listen(3000);
};

bootstrap();
