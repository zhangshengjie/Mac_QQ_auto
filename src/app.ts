/*
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2021-08-07 22:36:38
 * @LastEditors: cejay
 * @LastEditTime: 2021-10-20 14:57:15
 */
import got from 'got';
import path from 'path';
import fs from 'fs-extra';
import * as shell from 'shelljs'
const { spawn } = require('child_process');
import moment from 'moment-timezone';
import * as clipboard from 'simple-mac-clipboard';
moment.tz.setDefault('Asia/Singapore');


function asyncsleep(time = 0) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve(true);
        }, time);
    });
}
function consoleTimeLog(msg: string) {
    console.log(`${moment().format("HH:mm:ss.SSS")}\t${msg}`);
}

class QQMsg {
    constructor(uidump: string[], index: number) {
        if (uidump.length >= 4 && uidump.length <= 5) {
            let b = uidump[0].trim().substring(3).split(',');
            if (b.length === 4) {
                this.bounds = new Bounds();
                this.bounds.x = parseInt(b[0]);
                this.bounds.y = parseInt(b[1]);
                this.bounds.h = parseInt(b[3]);
                this.bounds.w = parseInt(b[2]);
                this.index = index;

                this.time = uidump[uidump.length - 1];
                this.name = uidump[uidump.length - 3];
                this.msg = uidump[uidump.length - 2];
                if (!this.msg.endsWith("已成为你的好友,开始聊天吧") && !(this.name === "好友验证消息")) {

                    if (uidump.length === 5) {
                        this.unread = parseInt(uidump[1]);
                    }
                    this.succ = true;
                }


            }
        }
    }

    succ = false;

    unread: number = 0;
    name: string = '';
    msg: string = '';
    time: string = '';
    bounds: Bounds = new Bounds();
    index = 0;

}
class Bounds {
    x = 0;
    y = 0;
    h = 0;
    w = 0;
}


var QQMapLastMsg = new Map<string, string>();

var QQMap = new Map<string, QQMsg>();

var ignoreQQ = new Set<string>();

var uidumpEnd = true;
function uidump() {
    if (uidumpEnd === false) {
        return;
    }
    uidumpEnd = false;
    let winMaxY = 0;
    let itemCache: string[] = [];
    let index = 0;
    let osascript = spawn('osascript', ['/Users/cejay/Documents/GitHub/Mac_QQ_auto/uidump.applescript']);

    osascript.stdout.on('data', (data: any) => {
        console.log(`stdout: ${data}`);
    });

    osascript.stderr.on('data', (data: Buffer[]) => {
        //console.error(`stderr: ${data}`);
        let uiLog = data.toString().trim();
        if (uiLog.startsWith('ps,')) {
            if (itemCache.length > 0) {
                let item = new QQMsg(itemCache, index++);
                itemCache = [];
                if (item.succ) {
                    if (item.bounds.y < 0 || (item.bounds.y + item.bounds.h) >= winMaxY) {
                        spawn('kill', [osascript.pid]);
                    } else {
                        QQMap.set(item.name, item);
                        //console.log(item);
                    }
                }
            }
            itemCache.push(uiLog);
        } else if (uiLog.startsWith("maxY:")) {
            winMaxY = parseInt(uiLog.substring(5));
        } else {
            let index1 = uiLog.indexOf("static text ");
            let index2 = uiLog.lastIndexOf(" of UI element 1 of row ");
            if (index1 === 0 && index2 > 0) {
                itemCache.push(uiLog.substring("static text ".length, index2));
            }

        }

    });
    osascript.on('close', (code: any) => {
        uidumpEnd = true;
        //console.log(`child process exited with code ${code}`);
    });
}

async function openChatSend(msg: string, x: number, y: number) {
    consoleTimeLog(`click ${x},${y}`);
    if (clipboard.writeText(clipboard.FORMAT_PLAIN_TEXT, msg)) {
        await click(x, y);
        //shell.exec(`osascript /Users/cejay/Documents/GitHub/Mac_QQ_auto/sendmsg.applescript`);
        return true;
    } else {
        consoleTimeLog("剪切板操作失败");
    }
    return false;
}
async function click(x: number, y: number) {
    shell.exec(`${clickPath} -x ${x} -y ${y}`);
}

var autoMsg = "这是一条自动回复/菜汪，被回复的内容是:\n";

//var clickPath = path.join(__dirname, 'click');
var clickPath = './click';
async function main() {
    consoleTimeLog(`根目录 ${__dirname}`);
    if ('darwin' !== process.platform) {
        consoleTimeLog("只能在 MacOS 运行");
        return;
    }
    if (!shell.which('osascript')) {
        consoleTimeLog("系统缺少必要osa文件");
        return;
    }
    if (!fs.existsSync(clickPath)) {
        consoleTimeLog("系统缺少必要click文件");
        return;
    }
    shell.chmod('777', clickPath);



    consoleTimeLog("开始运行");
    let firstInit = true;
    while (true) {
        if (uidumpEnd) {
            consoleTimeLog('===========');
            //判断是否需要回复消息
            if (QQMap.size > 0) {
                if (firstInit) {
                    for (const item of QQMap) {
                        if (!QQMapLastMsg.has(item[0])) {
                            consoleTimeLog(`init\t${item[0]}\t${item[1].msg}`);
                            QQMapLastMsg.set(item[0], item[1].msg);
                        }
                    }
                    firstInit = false;
                    consoleTimeLog("初始化完成，已加载" + QQMapLastMsg.size + "个聊天窗口");
                } else {
                    let sendMsgPre: QQMsg[] = [];
                    for (const item of QQMap) {
                        if (!QQMapLastMsg.has(item[0])) {
                            QQMapLastMsg.set(item[0], '');
                        }
                        //判断是否新消息
                        let msg = QQMapLastMsg.get(item[0]);
                        if (msg != item[1].msg) {
                            consoleTimeLog(`change\t${item[0]}\t ${msg} -> ${item[1].msg}`);
                            if (ignoreQQ.has(item[0])) {
                                consoleTimeLog(`忽略此消息`);
                                ignoreQQ.delete(item[0]);
                                QQMapLastMsg.set(item[0], item[1].msg);
                            } else {
                                sendMsgPre.push(item[1]);
                            }

                        }
                    }
                    if (sendMsgPre.length > 0) {
                        sendMsgPre = sendMsgPre.sort(function (a, b) { return b.index - a.index });
                        for (let index = 0; index < sendMsgPre.length; index++) {
                            const element = sendMsgPre[index];
                            let sendmsg = autoMsg + element.msg;
                            if (await openChatSend(sendmsg, element.bounds.x + Math.floor(element.bounds.w / 2), element.bounds.y + Math.floor(element.bounds.h / 2))) {
                                QQMapLastMsg.set(element.name, sendmsg);
                                ignoreQQ.add(element.name);
                                consoleTimeLog(`${element.name} => ${sendmsg}`);
                            }
                        }
                    }
                }
            }


        }

        uidump();
        await asyncsleep(500);
    }





}

main();