//init prisma client and inser from json in db

import { PrismaClient } from "@prisma/client";
import { MD5 } from "crypto-js";


const prisma = new PrismaClient();
async function main() {
	const password = process.env.password
	if (typeof password === "undefined") {
		throw new Error("password is undefined")
	}
	// await prisma.ps_auths.create({
	// 	data: {
	// 		id: "goip_16_2",
	// 		username: "goip_16_2",
	// 		md5_cred: MD5(password).toString(),
	// 		auth_type: "md5",
	// 	}
	// })
	console.log("auth")
	await prisma.ps_auths.create({
		data: {
			id: "goip_16_2",
			username: "goip_16_2",
			password: password,
			auth_type: "userpass",
		}
	})
	console.log("endpoint")
	await prisma.ps_endpoints.create({
		data: {
			id: "goip_16_2",
			aors: "goip_16_2",
			transport: "transport-udp",
			auth: "goip_16_2",
			disable_direct_media_on_nat: "yes",
			dtmf_mode: "auto",
			force_rport: "yes",
			direct_media: "no",
			// disallow: "all",
			// allow: "ulaw,alaw",
			direct_media_method: null
		}
	})
	await prisma.ps_aors.create({
		data: {
			id: "goip_16_2",
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
	// 		appdata: "PJSIP/goip_16__2/${EXTEN}"
	// 	}
	// })
	// await prisma.extensions.create({
	// 	data: {
	// 		context: "default",
	// 		exten: "_XXXXXXXXXXX",
	// 		priority: 1,
	// 		app: "Dial",
	// 		appdata: "PJSIP/goip_16__2/${EXTEN}"
	// 	}
	// })
	// await prisma.extensions.create({
	// 	data: {
	// 		context: "default",
	// 		exten: "_8XXXXXXXXX",
	// 		priority: 1,
	// 		app: "Dial",
	// 		appdata: "PJSIP/goip_16__2/${EXTEN}"
	// 	}
	// })
	await prisma.ps_aors.create({
		data: {
			id: "104",
			max_contacts: 1
		}
	})
	await prisma.ps_aors.create({
		data: {
			id: "goip_aor",
			max_contacts: 16
			// contact: "sip:10.0.0.10:5060"
		}
	})
	await prisma.ps_registrations.create({
		data: {
			id: "goip_register",
			auth_rejection_permanent: "no",
			support_path: "no",
			outbound_auth: "goip_16_2",
			transport: "transport-udp",
			endpoint: "10.0.0.10",
			support_outbound: "yes"
		}
	})
	await prisma.iaxfriends.create({
		data: {
			trunk: "yes",
			name: "goip_16_2",
			type: "peer",
			secret: password,
			context: "from-trunk",
			host: "10.0.0.10",
			port: 5060,
			auth: "goip_16_2"
		}
	})
	await prisma.extensions.create({
		data: {
			context: "from-trunk",
			exten: "104",
			priority: 1,
			app: "Set",
			appdata: "no"
		}
	})
	// await prisma.sippeers.create({
	// 	data: {
	// 		name: "goip",
	// 		ipaddr: "10.0.0.10",
	// 		port: 5060,
	// 		md5secret: md5HashedPassword,
	// 		transport: "udp",
	// 		dtmfmode: "auto",
	// 		directmedia: "no",
	// 		nat: "no",
	// 		insecure: "port,invite",
	// 		defaultuser: "goip_16_2",
	// 		auth: "goip_auth",
	// 		fromdomain: "10.0.0.10",
	// 		fromuser: "goip_16_2",
	// 		trunkname: "goip_16_2"
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