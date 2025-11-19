############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("startupmodule")
#endregion

############################################################
import { startListen } from "./receivermodule.js"

############################################################
export serviceStartup = ->
    log "serviceStartup"
    startListen()
    return
