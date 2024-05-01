
import { PrismaClient } from "@prisma/client";
import { pjsip } from "./seed/pjsip";
import { trunks } from "./seed/trunks";
import { trunk_dialpatterns } from "./seed/trunk_dialpatterns";

const prisma = new PrismaClient();
async function main() {
	await prisma.trunks.deleteMany({
		where: {
			trunkid: {
				in: trunks.trunks.map(trunk => trunk.trunkid)
			}
		}
	})
	await prisma.pjsip.deleteMany({
		where: {
			id: {
				in: pjsip.pjsip.map(pjsip => pjsip.id)
			}
		}
	})
	await prisma.trunk_dialpatterns.deleteMany({
		where: {
			trunkid: {
				in: trunk_dialpatterns.trunk_dialpatterns.map(trunk_dialpattern => trunk_dialpattern.trunkid)
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