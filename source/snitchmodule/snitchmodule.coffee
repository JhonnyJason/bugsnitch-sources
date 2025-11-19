############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("snitchmodule")
#endregion

############################################################
#region Local Variables
tgUrlSendMessage = null
chatId = null
hostname = null

############################################################
setReady = null
ready = new Promise((rslv) -> setReady = rslv)

############################################################
knownReports = new Set()

#endregion

############################################################
export initialize = (c) ->
    log "initialize"
    chatId = c.snitchChatId
    hostname = c.hostname

    tgUrlSendMessage = 'https://api.telegram.org/bot' + c.telegramToken + '/sendMessage'
    setReady()
    return


############################################################
send = (msg) ->
    await ready
    options = {
        method: 'POST'
        headers: { 'Content-Type': 'application/json' }
        body: '{"chat_id":'+chatId+',"text":"'+msg+'"}'
    }
    try resp = await fetch(tgUrlSendMessage, options)
    catch err then console.error(err)
    
    if !resp.ok then console.error("Telegram Response was not OK! (#{resp.status})")
    return

############################################################
export report = (msg) ->
    log "report"
    
    if knownReports.has(msg) then return
    knownReports.add(msg)

    send(hostname+':\n'+msg)
    log("reported:\n"+msg)
    return

