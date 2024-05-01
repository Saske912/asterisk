//init prisma client and inser from json in db

import { PrismaClient } from "@prisma/client";
import { pjsip } from "./seed/pjsip";
import { trunks } from "./seed/trunks";
import { trunk_dialpatterns } from "./seed/trunk_dialpatterns";

const prisma = new PrismaClient();
async function main() {
	await prisma.pjsip.createMany({
		data: pjsip.pjsip,
	});
	await prisma.trunks.createMany({
		data: trunks.trunks,
	});
	await prisma.trunk_dialpatterns.createMany({
		data: trunk_dialpatterns.trunk_dialpatterns,
	});
}
main()
	.catch((e) => {
		console.error(e);
	})
	.finally(async () => {
		await prisma.$disconnect();
	});