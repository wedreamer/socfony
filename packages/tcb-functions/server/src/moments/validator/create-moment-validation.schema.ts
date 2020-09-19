import Joi from "joi";
import { tcbStorageCloudFileIdToPath } from "src/utils/cloudbase.util";
import { tcbStorageFileIsAudioValidator, tcbStorageFileIsImageValidator, tcbStorageFileIsVideoValidator } from "src/validator/tcb-storage-file.validator";

export const CreateMomentValidationSchema = Joi.object({
    text: Joi.string()
        .max(5000)
        .required()
        .label('内容'),
    images: Joi.array().unique().max(9).items(
        Joi.string().external(tcbStorageFileIsImageValidator).required(),
    ).label('图片'),
    video: Joi.object({
        cover: Joi.string().external(tcbStorageCloudFileIdToPath).required(),
        src: Joi.string().external(tcbStorageFileIsVideoValidator).required(),
    }),
    audio: Joi.object({
        cover: Joi.string().external(tcbStorageCloudFileIdToPath),
        src: Joi.string().external(tcbStorageFileIsAudioValidator).required(),
    }),
    vote: Joi.array().unique().min(2).max(5).items(
        Joi.string().required().min(1).max(20),
    ),
    location: Joi.object({
        longitude: Joi.number().required(),
        latitude: Joi.number().required(),
    }),
});
