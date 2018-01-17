# SHIOLINK

SHIORI-Basic の実装です。

旧SHIOLINKと互換性の無い新プロトコルにした方が良い気がするので名前は変更する可能性があります。

## shiolink.dll

```bash
nimble install
nim c --app:lib -d:release --cpu:i386 shiolink.nim
```

## shiolink.exe (テスト用)

```bash
nimble install
nim c -r shiolink.nim
```

## License

This is released unser [MIT License](https://narazaka.net/license/MIT?2018)
