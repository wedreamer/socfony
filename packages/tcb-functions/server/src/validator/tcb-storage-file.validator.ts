import { IFileInfo } from "@cloudbase/manager-node/types/interfaces";
import { createCloudBaseManager, tcbStorageCloudFileIdToPath } from "src/utils/cloudbase.util";

export async function tcbStorageFileExistsValidator(fileId: string, allowsMeta: boolean = false): Promise<string | IFileInfo> {
    const manager = createCloudBaseManager();
    const path = tcbStorageCloudFileIdToPath(fileId);

    if (!fileId.startsWith('cloud://')) {
        throw new Error('不是正确的文件资源地址');
    }

    try {
        const meta = await manager.storage.getFileInfo(path);
        if (allowsMeta) {
            return meta;
        }

        return fileId;
    } catch {
        throw new Error('文件资源不存在');
    }
}

export async function tcbStorageFileIsImageValidator(fileId: string): Promise<string> {
    const meta = await tcbStorageFileExistsValidator(fileId, true) as IFileInfo;
    if (meta.Type.match('image/*')) {
        return fileId;
    }

    throw new Error('文件资源不是合法的图片');
}

export async function tcbStorageFileIsVideoValidator(fileId: string): Promise<string> {
    const meta = await tcbStorageFileExistsValidator(fileId, true) as IFileInfo;
    if (meta.Type.match('video/*')) {
        return fileId;
    }

    throw new Error('文件资源不是合法的视频');
}

export async function tcbStorageFileIsAudioValidator(fileId: string): Promise<string> {
    const meta = await tcbStorageFileExistsValidator(fileId, true) as IFileInfo;
    if (meta.Type.match('audio/mp4')) {
        return fileId;
    }

    throw new Error('文件资源不是合法的音频资源');
}

// export function TcbStorageFileExists(validationOptions?: ValidationOptions) {
//     return function(object: Object, propertyName: string) {
//         registerDecorator({
//             target: object.constructor,
//             propertyName,
//             options: validationOptions,
//             validator: TcbStorageFileExistsConstraint,
//         });
//     }
// }

// @ValidatorConstraint({ async: true })
// export class TcbStorageFileIsImageConstraint extends TcbStorageFileValidatorAbstract implements ValidatorConstraintInterface {
//     async validate(value: string): Promise<boolean> {
//         try {
//             const file = await this.queryFileInfo(value);
//             return file && file.Type.match('image/*') != null;
//         } catch {
//             return false;
//         }
//     }
    
//     defaultMessage?(validationArguments?: ValidationArguments): string {
//         return `${validationArguments.value} 不是合法的图片`;
//     }
// }

// export function TcbStorageFileIsImage(validationOptions?: ValidationOptions) {
//     return function(object: Object, propertyName: string) {
//         registerDecorator({
//             target: object.constructor,
//             propertyName,
//             options: validationOptions,
//             validator: TcbStorageFileIsImageConstraint,
//         });
//     }
// }
