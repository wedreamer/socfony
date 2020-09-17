import Joi from "joi";
import { tcbStorageFileIsImageValidator } from "src/validator/tcb-storage-file.validator";
import { TcbDatabaseTopicNotExists } from "./topic.valicator";

export const CreateTopicValicationSchema = Joi.object({
    cover: Joi.string().external(tcbStorageFileIsImageValidator).required(),
    name: Joi.string().required().external(TcbDatabaseTopicNotExists),
    description: Joi.string().required(),
    title: Joi.string().required(),
    joinType: Joi.string().valid('freely', 'examine').default('freely'),
    postType: Joi.string().valid('any', 'text', 'image', 'audio', 'video').default('any'),
});
