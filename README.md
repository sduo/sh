# msjdk.sh
* ```-v``` | ```--version```：指定需要安装的版本，详见：[在 Ubuntu 上安装](https://learn.microsoft.com/java/openjdk/install#install-on-ubuntu)

# golang.sh
* ```--gz```：golang 的 gz 压缩包
* ```--dl```：golang 的下载网页，默认：```https://go.dev/dl/```，可选：```https://golang.google.cn/dl/```
* ```-d``` | ```--directory``` | ```--folder```：安装 golang 的目录（```${GOROOT}```）
* ```-f``` | ```--force```：如果 golang 安装目录存在，则清理后再安装
* ```-a``` | ```--all```：将 ```${GOROOT}``` 和 ```${GOPATH}``` 环境变量导出到 ```/etc/bash.bashrc``` 中，默认：```~/.bashrc```
