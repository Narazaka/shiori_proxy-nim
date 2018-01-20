# Package

version       = "1.0.0"
author        = "Narazaka"
description   = "SHIORI Basic implementation"
license       = "MIT"

skipDirs = @["example"]

# Dependencies

requires "nim >= 0.17.2"
requires "shioridll"
requires "shiori_charset_convert"
requires "yaml"

task dll32, "build 32bit dll":
    exec "nim c --cc:vcc --app:lib -d:release --cpu:i386 shiori_proxy.nim"

task example, "run example":
    exec "nim c example/myshiori.nim"
    exec "nim c -r shiori_proxy.nim"
