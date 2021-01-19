import { NestJS, Kernel } from '~deps';

@NestJS.Common.Injectable()
export class UserProfileService {
  constructor(private readonly prisma: Kernel.Prisma.PrismaClient) {}

  /**
   * Query or create user profile.
   * @param user Need fetch profile user.
   */
  async resolveProfile(
    user: Kernel.Prisma.User,
  ): Promise<Kernel.Prisma.UserProfile> {
    const profile = await this.prisma.userProfile.findUnique({
      where: { userId: user.id },
    });
    if (!profile) {
      return await this.prisma.userProfile.create({
        data: {
          id: Kernel.Core.nanoIdGenerator(32),
          userId: user.id,
        },
      });
    }

    return profile;
  }
}
