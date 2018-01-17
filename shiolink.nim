import shiori
import shioridll
import nuuid # not secure random
import parsecfg
import osproc
import streams
import strutils

var config: Config
var commandline: string
var charmode: string
var timeout: string
var friendlyerror: string
var shioriProcess: Process
var shioriStdin: Stream
var shioriStdout: Stream

shioriLoadCallback = proc (dirpath: string): bool =
    config = loadConfig("shiolink.ini")
    commandline = config.getSectionValue("SHIOLINK", "commandline")
    charmode = config.getSectionValue("SHIOLINK", "charmode")
    timeout = config.getSectionValue("SHIOLINK", "timeout")
    friendlyerror = config.getSectionValue("SHIOLINK", "friendlyerror")

    var commandTokens = commandline.split(" ") # TODO: arg parse
    shioriProcess = startProcess(commandTokens[0], ".", commandTokens[1..^1]) # TODO: config
    shioriStdin = shioriProcess.inputStream
    shioriStdout = shioriProcess.outputStream

    shioriStdin.writeLine("*L:" & dirpath)
    true

shioriRequestCallback = proc (requestStr: string): string =
    let uuid: string = generateUUID()
    let sendCommandLine = "*S:" & uuid
    shioriStdin.writeLine(sendCommandLine)
    let recvCommandLine = shioriStdout.readLine()
    if sendCommandLine != recvCommandLine:
        raise newException(ValueError, "invalid return line")
    shioriStdin.write(requestStr)
    var line: string = ""
    var lines: seq[string] = @[]
    while shioriStdout.readLine(line):
        lines.add(line)
        if line.len() == 0:
            break
    return lines.join("\n")

shioriUnloadCallback = proc (): bool =
    shioriStdin.writeLine("*U:")
    shioriProcess.close()
    true

when appType != "lib":
    main("C:\\ssp\\ghost\\nim\\", @[
        "GET SHIORI/3.0\nCharset: UTF-8\nSender: embryo\nID: version\n\n",
        "GET SHIORI/3.0\nCharset: UTF-8\nSender: embryo\nID: OnBoot\n\n",
    ])
