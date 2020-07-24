'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var cloudbase = require('@bytegem/cloudbase');

var name = "moment";
var version = "1.0.0";

class PostCommand extends cloudbase.Command {
    handle(app, data) {
        throw new Error("Method not implemented.");
    }
}

function main(event, context) {
    const app = new cloudbase.Application({
        context,
        name,
        version,
    });
    app.addCommand('post', () => new PostCommand);
    return app.run(event);
}

exports.main = main;
