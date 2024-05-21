//init prisma client and inser from json in db

import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();
async function main() {
	const password = process.env.password
	if (typeof password === "undefined") {
		throw new Error("password is undefined")
	}
	// await prisma.ps_aors.create({
	// 	data: {
	// 		id: "goip_16_2",
	// 		max_contacts: 16,
	// 	}
	// })
	await prisma.ps_aors.create({
		data: {
			id: "104",
			max_contacts: 1
		}
	})
	await prisma.ps_auths.create({
		data: {
			id: "104",
			username: "104",
			password: "saveli12",
			auth_type: "userpass",
		}
	})
	await prisma.ps_endpoints.create({
		data: {
			id: "104",
			aors: "104",
			transport: "transport-udp",
			auth: "104",
			disable_direct_media_on_nat: "yes",
			context: "default",
			dtmf_mode: "auto",
			ice_support: "yes",
			direct_media: "no",
			disallow: "all",
			allow: "ulaw,alaw",
			direct_media_method: null
		}
	})
	await prisma.ps_aors.create({
		data: {
			id: "103",
			max_contacts: 1
		}
	})
	await prisma.ps_auths.create({
		data: {
			id: "103",
			username: "103",
			password: "saveli12",
			auth_type: "userpass",
		}
	})
	await prisma.ps_endpoints.create({
		data: {
			id: "103",
			aors: "103",
			transport: "transport-udp",
			callerid: "Mihail<103>",
			auth: "103",
			disable_direct_media_on_nat: "yes",
			context: "default",
			dtmf_mode: "auto",
			force_rport: "yes",
			ice_support: "yes",
			direct_media: "no",
			disallow: "all",
			allow: "ulaw,alaw",
			direct_media_method: null
		}
	})
	// await prisma.extensions.create({
	// 	data: {
	// 		context: "default",
	// 		exten: "_+7XXXXXXXXXX",
	// 		priority: 1,
	// 		app: "Dial",
	// 		appdata: "PJSIP/8${EXTEN:2}@goip_16_2"
	// 	}
	// })
	// await prisma.extensions.create({
	// 	data: {
	// 		context: "default",
	// 		exten: "_+7XXXXXXXXXX",
	// 		priority: 2,
	// 		app: "System",
	// 		appdata: '/bin/echo -e "Dial Status is ${ DIALSTATUS }"'
	// 	}
	// })
	// await prisma.extensions.create({
	// 	data: {
	// 		context: "default",
	// 		exten: "_+7XXXXXXXXXX",
	// 		priority: 2,
	// 		app: "Hangup",
	// 		// appdata: "PJSIP/8${EXTEN:2}@goip_16_2"
	// 		// appdata: "SIP/goip_16_2/{EXTEN}"
	// 		appdata: ""
	// 	}
	// })
	// await prisma.extensions.create({
	// 	data: {
	// 		context: "default",
	// 		exten: "_+7.",
	// 		priority: 1,
	// 		app: "Dial",
	// 		appdata: "PJSIP/goip_16_2/${EXTEN}"
	// 	}
	// })
	// await prisma.extensions.create({
	// 	data: {
	// 		context: "default",
	// 		exten: "_XXXXXXXXXXX",
	// 		priority: 1,
	// 		app: "Dial",
	// 		appdata: "PJSIP/goip_16_2/${EXTEN}"
	// 	}
	// })
	// await prisma.extensions.create({
	// 	data: {
	// 		context: "default",
	// 		exten: "_8XXXXXXXXXX",
	// 		priority: 1,
	// 		app: "Dial",
	// 		appdata: "PJSIP/goip_16_2/${EXTEN}"
	// 	}
	// })
}
main()
	.catch((e) => {
		console.error(e);
	})
	.finally(async () => {
		await prisma.$disconnect();
	});