import shiori
import strutils
import tables

var dirpath: string

proc load(): void =
    dirpath = stdin.readLine()
    stdout.writeLine("1")
    stdout.flushFile()

proc unload(): void =
    stdout.writeLine("1")
    stdout.flushFile()

proc request(): void =
    var lines: seq[string] = @[]
    while true:
        let line = stdin.readLine()
        lines.add(line & "\n")
        if line.len == 0:
            break
    let request = parseRequest(lines.join(""))
    var response = newResponse(headers = {"Charset": "Shift_JIS", "Sender": "myshiori"}.newOrderedTable)

    if request.version != "3.0":
        response.status = Bad_Request
        stdout.write($response)
        return

    case request.id:
        of "version": response.value = "1.0.0"
        of "OnBoot": response.value = r"\h\s[0]hello\e"
        else: response.status = No_Content

    stdout.write($response)
    stdout.flushFile()

while true:
    let commandLine = stdin.readLine()
    case commandLine:
        of "LOAD SHIORIPROXY/1.0": load()
        of "UNLOAD SHIORIPROXY/1.0": unload()
        of "REQUEST SHIORIPROXY/1.0": request()
