# shiori_proxy

SHIORI-Basic の実装です。

## 概要

伺かにおけるSHIORIサブシステムはアンマネージドdllによる実装が仕様となっていますが、
コンソールアプリケーションの方が一般に作成しやすいです。

このshiori_proxy.dllは、コンソールアプリケーションとの標準入出力でSHIORIサブシステムを実現するためのラッパーです。

## 設定

`shiori_proxy.yml`で行います

```yaml
command: # 実行コマンド 引数を配列にしたもの
- node.exe
- shiori.js
- ./dict
timeout: 5 # タイムアウト秒
```

### command 実行コマンド

shiori_proxy.dllは、SHIORI load()時にコマンドを実行してSHIORIプロセスを立ち上げ、SHIORI unload()時にそれを終了します。

load()時に立ち上げるコマンド引数を配列で記述します。

### timeout タイムアウト秒

SHIORIプロセスにリクエストを投げてもこの秒数以内にレスポンスが帰ってこなかった場合、shiori_proxy.dllはSHIORIプロセスがハングしたとみなし、異常終了します。

ベースウェアの実装によってはベースウェアごと落ちますが、そうしない場合ベースウェアごと無限にフリーズして操作不能となる場合が存在する(SSPなど)ので、このような処理を搭載しています。

## プロトコル

shiori_proxy.dllとSHIORIプロセスの間の通信プロトコルは以下のようなものです。

| 種別 | shiori_proxy.dll | SHIORIプロセス |
|---|---|---|
| (SHIORIプロセス起動) | | |
| load() リクエスト | LOAD SHIORIPROXY/1.0[CRLF]<br>C:\\SSP\\ghost\\ikaga\\ghost\\master\\[CRLF] | |
| load() レスポンス | | 1[CRLF] |
| request() リクエスト | REQUEST SHIORIPROXY/1.0[CRLF]<br>GET SHIORI/3.0[CRLF]<br>Charset: Shift_JIS[CRLF]<br>Sender: ikagaka[CRLF]<br>ID: version[CRLF]<br>[CRLF] | |
| request() レスポンス | | SHIORI/3.0 200 OK[CRLF]<br>Charset: Shift_JIS[CRLF]<br>Sender: ikaga[CRLF]<br>Value: 1.0.0[CRLF]<br>[CRLF] |
| unload() リクエスト | UNLOAD SHIORIPROXY/1.0[CRLF] | |
| unload() レスポンス | | 1[CRLF] |
| (SHIORIプロセス終了) | | |

## 文字コード

shiori_proxy.dllはSHIORIプロセスに標準入力でSHIORIリクエストなどを受け渡し、標準出力からSHIORIレスポンスなどを受け取ります。

ベースウェアからはShift_JISまたはUTF-8でリクエストが来ることになりますが、実行コマンドでの扱いが簡単になるよう、shiori_proxy.dll内で文字コード変換を行います。

通信時の文字コードは以下のようになります。

- ベースウェアとshiori_proxy.dllの間はSHIORIリクエスト/レスポンスに含まれるCharsetヘッダの文字コード
- shiori_proxy.dllとSHIORIプロセスの間はUTF-8

このときSHIORIリクエストやレスポンスに付加されているCharsetヘッダは書き換えることなく文字コードのみ変換します。

なのでSHIORIプロセスが標準入力から読んだSHIORIリクエストはCharsetヘッダと実際の文字コードが異なる場合が存在します。

またCharsetヘッダと実際の文字コードが異なる状態でSHIORIプロセスから標準出力へSHIORIレスポンスを書き込む事も出来ます。

一覧すると、リクエスト、レスポンスともに以下のような状態になります。

| ベースウェア(SSP等) <-> shiori_proxy.dll | shiori_proxy.dll <-> SHIORIコマンド |
|---|---|---|
| Charset: Shift_JIS (実際=Shift_JIS) | Charset: Shift_JIS (実際=UTF-8) |
| Charset: UTF-8 (実際=UTF-8) | Charset: UTF-8 (実際=UTF-8) |

## ビルド

### shiori_proxy.dll

```bash
nimble install
nim c --app:lib -d:release --cc:vcc --cpu:i386 shiori_proxy.nim
```

### shiori_proxy.exe (テスト用)

```bash
nimble install
nim c -r shiori_proxy.nim
```

## License

This is released unser [MIT License](https://narazaka.net/license/MIT?2018)
