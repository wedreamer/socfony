import { Injectable } from '@nestjs/common';
import { PrismaClient, User, UserProfile } from '@prisma/client';
import { nanoIdGenerator } from 'src/helper';

@Injectable()
export class UserProfileService {
  constructor(private readonly prisma: PrismaClient) {}

  /**
   * Query or create user profile.
   * @param user Need fetch profile user.
   */
  async resolveProfile(user: User): Promise<UserProfile> {
    const profile = await this.prisma.userProfile.findUnique({
      where: { userId: user.id },
    });
    if (!profile) {
      return await this.prisma.userProfile.create({
        data: {
          id: nanoIdGenerator(32),
          userId: user.id,
        },
      });
    }

    return profile;
  }
}
