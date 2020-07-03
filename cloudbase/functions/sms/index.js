const { main } = require("./lib/main");

module.exports.main = async (event, context) => {
    try {
        await main(event, context);
    } catch (error) {
        return {
            hasError: true,
            message: error.message || "Unknow Error",
        };
    }
}
