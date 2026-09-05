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
fd3Receiver = null

fd3Available = false

############################################################
export initialize = (c) ->
    log "initialize"
    sPath = c.socketPath
    
    try fs.unlinkSync(sPath)
    catch err then log err

    receiver = net.createServer(onConnection)
    fd3Receiver = net.createServer(onConnection)

    listenFds = parseInt(process.env.LISTEN_FDS)
    listenPid = parseInt(process.env.LISTEN_PID)
    fd3Available = (process.pid  == listenPid) and (listenFds > 0)
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

    ## listen also on fd3 on system socket activation
    if fd3Available
        handle.fd = 3
        fd3Receiver.listen(handle)
        fd3Receiver.on("error", ((e) -> console.error(e)))
    
    ## create special socke anyways
    options = { path: sPath, writableAll: true }
    receiver.listen(options)
    receiver.on("error", ((e) -> console.error(e)))
  
    ## handle interrupt and terminate signals
    process.on("SIGTERM", onInterrupt)
    process.on("SIGINT", onInterrupt)
    return


