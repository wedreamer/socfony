const { main } = require("./lib/main");

module.exports.main = async (event, context) => {
    return await main(event, context);
}
