import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('Start seeding...');

  // Create demo users
  const user1Password = await bcrypt.hash('password123', 10);
  const user2Password = await bcrypt.hash('password123', 10);

  const user1 = await prisma.user.upsert({
    where: { email: 'alice@example.com' },
    update: {},
    create: {
      email: 'alice@example.com',
      username: 'alice',
      passwordHash: user1Password,
      displayName: 'Alice Johnson',
      bio: 'Software developer and tech enthusiast',
      isVerified: true,
    },
  });

  const user2 = await prisma.user.upsert({
    where: { email: 'bob@example.com' },
    update: {},
    create: {
      email: 'bob@example.com',
      username: 'bob',
      passwordHash: user2Password,
      displayName: 'Bob Smith',
      bio: 'Designer and photographer',
      isVerified: true,
    },
  });

  console.log('Users created:', { user1, user2 });

  // Create demo posts
  const post1 = await prisma.post.create({
    data: {
      content: 'Hello everyone! Excited to be here on Prava! 🎉',
      authorId: user1.id,
    },
  });

  const post2 = await prisma.post.create({
    data: {
      content: 'Just finished working on a new design project. Check it out!',
      authorId: user2.id,
    },
  });

  console.log('Posts created:', { post1, post2 });

  // Create demo comments
  const comment1 = await prisma.comment.create({
    data: {
      content: 'Welcome to Prava! Glad to have you here!',
      postId: post1.id,
      authorId: user2.id,
    },
  });

  console.log('Comment created:', comment1);

  // Create demo reactions
  const reaction1 = await prisma.reaction.create({
    data: {
      type: 'like',
      postId: post1.id,
      userId: user2.id,
    },
  });

  const reaction2 = await prisma.reaction.create({
    data: {
      type: 'love',
      postId: post2.id,
      userId: user1.id,
    },
  });

  console.log('Reactions created:', { reaction1, reaction2 });

  // Create demo conversation
  const conversation = await prisma.conversation.create({
    data: {
      name: null,
      isGroup: false,
      participants: {
        create: [
          { userId: user1.id },
          { userId: user2.id },
        ],
      },
    },
  });

  console.log('Conversation created:', conversation);

  // Create demo messages
  const message1 = await prisma.message.create({
    data: {
      content: 'Hey Bob! How are you doing?',
      conversationId: conversation.id,
      senderId: user1.id,
    },
  });

  const message2 = await prisma.message.create({
    data: {
      content: 'Hi Alice! I\'m doing great, thanks! How about you?',
      conversationId: conversation.id,
      senderId: user2.id,
    },
  });

  console.log('Messages created:', { message1, message2 });

  console.log('Seeding finished.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
