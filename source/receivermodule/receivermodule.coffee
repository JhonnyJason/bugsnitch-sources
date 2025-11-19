############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("receivermodule")
#endregion

############################################################
import net from "node:net"
import fs from "node:fs"

############################################################
import { report } from "./snitchmodule.js"

############################################################
sPath = null
receiver = null

############################################################
export initialize = (c) ->
    log "initialize"
    sPath = c.socketPath
    
    try fs.unlinkSync(sPath)
    catch err then log err

    receiver = net.createServer(onConnection)
    return

############################################################
onConnection = (sock) ->
    log 'onConnection'
    buf = ''
    sock.on('data', ((d) -> buf += d.toString('utf8')))
    sock.on('end', (() -> report(buf)))
    sock.on('error', ((e) -> console.error(e)))
    return

############################################################
onInterrupt = -> receiver.close((() -> log("onInterrupt: Shutting down. Bye!")))

# onInterrupt = ->
#     onClosed = ->
#         console.log("Gracefully Terminated. Bye!")
#         process.exit(0)
#         return
    
#     receover.close(onClosed)
#     return

############################################################
export startListen = ->
    log "startListen"
    options = 
        path: sPath
        writableAll: true
    
    receiver.listen(sPath)
    receiver.on("error", ((e) -> console.error(e)))
    process.on("SIGTERM", onInterrupt)
    process.on("SIGINT", onInterrupt)
    return


