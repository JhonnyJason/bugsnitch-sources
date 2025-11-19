############################################################
import fs from "fs"
import path from "path"

############################################################
localCfg = Object.create(null)

try
    ## read local config
    configPath = path.resolve(process.cwd(), "./.config.json")
    localCfgString = fs.readFileSync(configPath, 'utf8')
    localCfg = JSON.parse(localCfgString)
    
    ## read hostname
    hostName = (fs.readFileSync("/etc/hostname", "utf8")).trim()
catch err
    console.error(err)
    console.error("Fatal Error - we cannot recover. Bye!")
    process.exit(1)


############################################################
export socketPath = localCfg.socketPath || "/run/bugsnitch.sk"
export telegramToken = localCfg.telegramToken || ""
export snitchChatId = localCfg.snitchChatId || ""

############################################################
export hostname = hostName || ""

############################################################
## reset Local Variables
localCfg = undefined
hostName = undefined