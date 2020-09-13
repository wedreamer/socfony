import { createApp } from "./app";

console.log(process.env);

const bootstrap = async () => {
    const app = await createApp();
    const port = 3000;
    app.listen(port, () => console.log(`http://127.0.0.1:${port}`));
};

bootstrap();
