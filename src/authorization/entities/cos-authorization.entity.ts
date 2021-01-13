import { Field, GraphQLISODateTime, ObjectType } from '@nestjs/graphql';
import { GetFederationTokenResponse } from 'tencentcloud-sdk-nodejs/tencentcloud/services/sts/v20180813/sts_models';

@ObjectType()
export class CosAuthorizationEntity {
  @Field((type) => String)
  token: string;

  @Field((type) => String)
  secretId: string;

  @Field((type) => String)
  secretKey: string;

  @Field((type) => GraphQLISODateTime)
  expiredAt: Date;

  static create(response: GetFederationTokenResponse): CosAuthorizationEntity {
    const value = new CosAuthorizationEntity();
    value.token = response.Credentials.Token;
    value.secretId = response.Credentials.TmpSecretId;
    value.secretKey = response.Credentials.TmpSecretKey;
    value.expiredAt = new Date(response.Expiration);

    return value;
  }
}
