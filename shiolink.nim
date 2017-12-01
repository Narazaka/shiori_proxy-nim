import shiori
import shioridll
import nuuid # not secure random
import parsecfg
import osproc

var config: Config
var commandline: string
var charmode: string
var timeout: string
var friendlyerror: string

shioriLoadCallback = proc (dirpath: string): bool =
    config = loadConfig("shiolink.ini")
    commandline = config.getSectionValue("SHIOLINK", "commandline")
    charmode = config.getSectionValue("SHIOLINK", "charmode")
    timeout = config.getSectionValue("SHIOLINK", "timeout")
    friendlyerror = config.getSectionValue("SHIOLINK", "friendlyerror")
    let uuid: string = generateUUID()
    echo uuid
    true

shioriRequestCallback = proc (requestStr: string): string =
    return $newResponse(SHIORI, "3.0", Status.OK)

shioriUnloadCallback = proc (): bool =
    true

when appType != "lib":
    main("C:\\ssp\\ghost\\nim\\", @[
        "GET SHIORI/3.0\nCharset: UTF-8\nSender: embryo\nID: version\n\n",
        "GET SHIORI/3.0\nCharset: UTF-8\nSender: embryo\nID: OnBoot\n\n",
    ])
