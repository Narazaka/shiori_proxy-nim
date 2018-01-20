all: shiori_proxy.dll

shiori_proxy.dll: shiori_proxy.nim
	nim c --cc:vcc --app:lib -d:release --cpu:i386 shiori_proxy.nim

clean:
	rm -rf nimcache *.exe *.lib *.exp *.ilk *.pdb
