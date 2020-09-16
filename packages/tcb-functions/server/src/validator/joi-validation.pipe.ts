import { BadRequestException, PipeTransform, UnprocessableEntityException } from '@nestjs/common';
import { ObjectSchema, ValidationError } from 'joi';

export class JoiValidationPipe implements PipeTransform {
  constructor(private schema: ObjectSchema) {}

  async transform(value: any) {
    try {
      return await this.schema.validateAsync(value);
    } catch (error) {
      if (error instanceof ValidationError) {
        throw new UnprocessableEntityException({
          message: error.message,
          error,
        });
      } else if (typeof error.message == 'string' && error.message) {
        throw new BadRequestException({
          message: error.message,
          error,
        });
      }

      throw new BadRequestException();
    }
  }
}