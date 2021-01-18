import { NestJS, TencentCloud } from '~deps';

/**
 * Tencent Cloud COS endpoint authorization entity.
 */
@NestJS.GraphQL.ObjectType({
  description: 'Tencent Cloud COS endpoint authorization entity.',
})
export class CosAuthorizationEntity {
  /**
   * Tencent Cloud COS http endpoit authorization token.
   */
  @NestJS.GraphQL.Field((type) => String, {
    description: 'Tencent Cloud COS http endpoit authorization token.',
  })
  token: string;

  /**
   * Tencent Cloud COS bucket temporary secret ID
   */
  @NestJS.GraphQL.Field((type) => String, {
    description: 'Tencent Cloud COS bucket temporary secret ID',
  })
  secretId: string;

  /**
   * Tencent Cloud COS bucket temporary secret KEY
   */
  @NestJS.GraphQL.Field((type) => String, {
    description: 'Tencent Cloud COS bucket temporary secret KEY',
  })
  secretKey: string;

  /**
   * token expired at.
   */
  @NestJS.GraphQL.Field((type) => NestJS.GraphQL.GraphQLISODateTime, {
    description: 'token expired at.',
  })
  expiredAt: Date;

  /**
   * Only write credentials exist in the resource field.
   */
  @NestJS.GraphQL.Field((type) => String, {
    nullable: true,
    description: 'Only write credentials exist in the resource field.',
  })
  resource?: string;

  /**
   * Create a `CosAuthorizationEntity` using response.
   * @param response Tencent Cloud STS federation token response.
   */
  static create(
    response: TencentCloud.STS.GetFederationTokenResponse,
  ): CosAuthorizationEntity {
    const value = new CosAuthorizationEntity();
    value.token = response.Credentials.Token;
    value.secretId = response.Credentials.TmpSecretId;
    value.secretKey = response.Credentials.TmpSecretKey;
    value.expiredAt = new Date(response.Expiration);

    return value;
  }
}
