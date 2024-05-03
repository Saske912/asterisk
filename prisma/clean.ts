
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();
async function main() {
	await prisma.ps_endpoints.deleteMany({
		where: {
			id: {
				not: ""
			}
		}
	})
	await prisma.ps_auths.deleteMany({
		where: {
			id: {
				not: ""
			}
		}
	})
	await prisma.ps_registrations.deleteMany({
		where: {
			id: {
				not: ""
			}
		}
	})
	await prisma.sippeers.deleteMany({
		where: {
			name: {
				not: ""
			}
		}
	})
	await prisma.ps_aors.deleteMany({
		where: {
			id: {
				not: ""
			}
		}
	})
	await prisma.iaxfriends.deleteMany({
		where: {
			name: {
				not: ""
			}
		}
	})
	await prisma.extensions.deleteMany({
		where: {
			context: {
				not: ""
			}
		}
	})
}
main()
	.catch((e) => {
		console.error(e);
	})
	.finally(async () => {
		await prisma.$disconnect();
	});