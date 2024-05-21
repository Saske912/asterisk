//init prisma client and inser from json in db

import { PrismaClient } from "@prisma/client";
import { MD5 } from "crypto-js";


const prisma = new PrismaClient();
async function main() {
	const password = process.env.password
	if (typeof password === "undefined") {
		throw new Error("password is undefined")
	}
	await prisma.ps_auths.create({
		data: {
			// id: "goip_16_2",
			// username: "goip_16_2",
			id: "goip_16_2-iauth",
			username: "goip_16_2",
			password: password,
			auth_type: "userpass",
		}
	})
	console.log("auth created")
	// await prisma.ps_endpoints.create({
	// 	data: {
	// 		id: "goip_16_2",
	// 		aors: "goip_16_2",
	// 		// transport: "transport-udp",
	// 		auth: "goip_16_2",
	// 		disable_direct_media_on_nat: "yes",
	// 		outbound_auth: "goip_16_2",
	// 		dtmf_mode: "auto",
	// 		// callerid: "Goip<goip_16_2>",
	// 		context: "default",
	// 		force_rport: "yes",
	// 		direct_media: "no",
	// 		rewrite_contact: "yes",
	// 		// disallow: "all",
	// 		// allow: "ulaw,alaw",
	// 		// direct_media_method: null
	// 	}
	// })
	await prisma.ps_aors.create({
		data: {
			id: "goip_16_2",
			max_contacts: 16,
			// contact: "sip:goip_16_2@10.0.0.10:5060"
		}
	})
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
			force_rport: "yes",
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
	await prisma.extensions.create({
		data: {
			context: "default",
			exten: "_XXXXXXXXXXX",
			priority: 1,
			app: "Dial",
			appdata: "PJSIP/goip_16_2/${EXTEN}"
		}
	})
	await prisma.extensions.create({
		data: {
			context: "default",
			exten: "_8XXXXXXXXXX",
			priority: 1,
			app: "Dial",
			appdata: "PJSIP/goip_16_2/${EXTEN}"
		}
	})
	// await prisma.ps_registrations.create({
	// 	data: {
	// 		id: "goip_16_2",
	// 		auth_rejection_permanent: "no",
	// 		// support_path: "no",
	// 		outbound_auth: "goip_16_2",
	// 		transport: "transport-udp",
	// 		endpoint: "goip_16_2",
	// 		line: "yes",
	// 		// server_uri: "sip:10.0.0.10:5060\;transport=tcp",
	// 		server_uri: "sip:10.0.0.10:5060",
	// 		client_uri: "sip:goip_16_2@10.0.0.10:5060",
	// 		forbidden_retry_interval: 300,
	// 		// support_outbound: "yes",
	// 		contact_user: "goip_16_2",
	// 		retry_interval: 45,
	// 		max_retries: 10,
	// 	}
	// })
	// await prisma.ps_endpoint_id_ips.create({
	// 	data: {
	// 		id: "goip_16_2",
	// 		endpoint: "goip_16_2",
	// 		match: "10.0.0.10"
	// 	}
	// })
	// await prisma.iaxfriends.create({
	// 	data: {
	// 		trunk: "yes",
	// 		name: "goip_16_2",
	// 		type: "peer",
	// 		secret: password,
	// 		context: "from-trunk",
	// 		host: "10.0.0.10",
	// 		port: 5060,
	// 		auth: "goip_16_2"
	// 	}
	// })
	// await prisma.sippeers.create({
	// 	data: {
	// 		name: "goip_16_2",
	// 		ipaddr: "10.0.0.10",
	// 		context: "from-internal",
	// 		port: 5060,
	// 		md5secret: MD5(password).toString(),
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