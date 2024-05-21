"use strict";
//init prisma client and inser from json in db
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (g && (g = 0, op[0] && (_ = 0)), _) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
Object.defineProperty(exports, "__esModule", { value: true });
var client_1 = require("@prisma/client");
var prisma = new client_1.PrismaClient();
function main() {
    return __awaiter(this, void 0, void 0, function () {
        var password;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    password = process.env.password;
                    if (typeof password === "undefined") {
                        throw new Error("password is undefined");
                    }
                    return [4 /*yield*/, prisma.ps_auths.create({
                            data: {
                                // id: "goip_16_2",
                                // username: "goip_16_2",
                                id: "goip_16_2-iauth",
                                username: "goip_16_2",
                                password: password,
                                auth_type: "userpass",
                            }
                        })];
                case 1:
                    _a.sent();
                    console.log("auth created");
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
                    return [4 /*yield*/, prisma.ps_aors.create({
                            data: {
                                id: "goip_16_2",
                                max_contacts: 16,
                                // contact: "sip:goip_16_2@10.0.0.10:5060"
                            }
                        })];
                case 2:
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
                    _a.sent();
                    return [4 /*yield*/, prisma.ps_aors.create({
                            data: {
                                id: "104",
                                max_contacts: 1
                            }
                        })];
                case 3:
                    _a.sent();
                    return [4 /*yield*/, prisma.ps_auths.create({
                            data: {
                                id: "104",
                                username: "104",
                                password: "saveli12",
                                auth_type: "userpass",
                            }
                        })];
                case 4:
                    _a.sent();
                    return [4 /*yield*/, prisma.ps_endpoints.create({
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
                        })];
                case 5:
                    _a.sent();
                    return [4 /*yield*/, prisma.ps_aors.create({
                            data: {
                                id: "103",
                                max_contacts: 1
                            }
                        })];
                case 6:
                    _a.sent();
                    return [4 /*yield*/, prisma.ps_auths.create({
                            data: {
                                id: "103",
                                username: "103",
                                password: "saveli12",
                                auth_type: "userpass",
                            }
                        })];
                case 7:
                    _a.sent();
                    return [4 /*yield*/, prisma.ps_endpoints.create({
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
                    ];
                case 8:
                    _a.sent();
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
                    return [4 /*yield*/, prisma.extensions.create({
                            data: {
                                context: "default",
                                exten: "_XXXXXXXXXXX",
                                priority: 1,
                                app: "Dial",
                                appdata: "PJSIP/goip_16_2/${EXTEN}"
                            }
                        })];
                case 9:
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
                    _a.sent();
                    return [4 /*yield*/, prisma.extensions.create({
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
                    ];
                case 10:
                    _a.sent();
                    return [2 /*return*/];
            }
        });
    });
}
main()
    .catch(function (e) {
    console.error(e);
})
    .finally(function () { return __awaiter(void 0, void 0, void 0, function () {
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0: return [4 /*yield*/, prisma.$disconnect()];
            case 1:
                _a.sent();
                return [2 /*return*/];
        }
    });
}); });
