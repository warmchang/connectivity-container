# connectivity-container
A basic container with a simple golang HTTP server and with curl packaged in.

Fork from the origin [connectivity-container](https://github.com/cilium/connectivity-container).


# Build the image
## 1. Build in the container
Just run the command:
```
➜  connectivity-container git:(master) docker build -t connectivity-container:alpine3.8 .
Sending build context to Docker daemon  178.5MB
Step 1/10 : FROM golang:1.10.4-alpine3.8 as builder
1.10.4-alpine3.8: Pulling from library/golang
4fe2ade4980c: Pull complete
2e793f0ebe8a: Pull complete
77995fba1918: Pull complete
4495499e856d: Pull complete
0ff8f8e34aa6: Pull complete
Digest: sha256:a172b3fc8acce8cef2e81a7f40d1ac2759d615fac67bfc957a8f85fce725d1e6
Status: Downloaded newer image for golang:1.10.4-alpine3.8
 ---> bd36346540f3
Step 2/10 : WORKDIR /tmp
Removing intermediate container 52d36f7dd7e1
 ---> 37a3e99a123a
Step 3/10 : COPY main.go .
 ---> 12e66feca530
Step 4/10 : RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o connectivity-container .
 ---> Running in 853fd8c1ca52
Removing intermediate container 853fd8c1ca52
 ---> 79163cd59ccb
Step 5/10 : FROM alpine:3.8
3.8: Pulling from library/alpine
4fe2ade4980c: Already exists
Digest: sha256:09ead89b28f17dbc9584f10fd6998b32b8950404c6c6e02aefab509d0e66ea35
Status: Downloaded newer image for alpine:3.8
 ---> 196d12cf6ab1
Step 6/10 : WORKDIR /root/
Removing intermediate container d389928af4f7
 ---> 0de9c1ed27e4
Step 7/10 : EXPOSE 8028
 ---> Running in 9f71f4a3a67e
Removing intermediate container 9f71f4a3a67e
 ---> 366e7fbf56bc
Step 8/10 : RUN apk add --no-cache curl
 ---> Running in 258158d310ee
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/community/x86_64/APKINDEX.tar.gz
(1/5) Installing ca-certificates (20171114-r3)
(2/5) Installing nghttp2-libs (1.32.0-r0)
(3/5) Installing libssh2 (1.8.0-r3)
(4/5) Installing libcurl (7.61.1-r0)
(5/5) Installing curl (7.61.1-r0)
Executing busybox-1.28.4-r1.trigger
Executing ca-certificates-20171114-r3.trigger
OK: 6 MiB in 18 packages
Removing intermediate container 258158d310ee
 ---> 84feb06792ef
Step 9/10 : COPY --from=builder /tmp/connectivity-container .
 ---> 22dce353dc04
Step 10/10 : CMD ["./connectivity-container"]
 ---> Running in 09c5b476e1a3
Removing intermediate container 09c5b476e1a3
 ---> 33e7b3dbf394
Successfully built 33e7b3dbf394
Successfully tagged connectivity-container:alpine3.8
➜  connectivity-container git:(master) docker images | grep connectivity-container
connectivity-container   alpine3.8            33e7b3dbf394        3 minutes ago       10.1MB
➜  connectivity-container git:(master)
```

## 2. Build on host

* prepare the golang env
* prepare the docker env
* build connectivity-container binary

```
➜  connectivity-container git:(master) CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o connectivity-container .
```
* build the connectivity-container image

```
➜  connectivity-container git:(master) docker build -t connectivity-container:alpine3.8 -f ./Dockerfile-1.12.6 .
Sending build context to Docker daemon 169.4 MB
Step 1 : FROM alpine:3.8
 ---> 196d12cf6ab1
Step 2 : MAINTAINER William Zhang "warmchang@outlook.com"
 ---> Running in ae48ce5e23e2
 ---> f59c2207b508
Removing intermediate container ae48ce5e23e2
Step 3 : WORKDIR /root/
 ---> Running in a6c762013f6b
 ---> baf79f4c8a20
Removing intermediate container a6c762013f6b
Step 4 : EXPOSE 8028
 ---> Running in 4ee61213fad1
 ---> f903f923bcaa
Removing intermediate container 4ee61213fad1
Step 5 : RUN apk add --no-cache curl
 ---> Running in 84ecaf2d4b93
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/community/x86_64/APKINDEX.tar.gz
(1/5) Installing ca-certificates (20171114-r3)
(2/5) Installing nghttp2-libs (1.32.0-r0)
(3/5) Installing libssh2 (1.8.0-r3)
(4/5) Installing libcurl (7.61.1-r0)
(5/5) Installing curl (7.61.1-r0)
Executing busybox-1.28.4-r1.trigger
Executing ca-certificates-20171114-r3.trigger
OK: 6 MiB in 18 packages
 ---> 49588572e912
Removing intermediate container 84ecaf2d4b93
Step 6 : COPY ./connectivity-container .
 ---> 0c3b4d95641e
Removing intermediate container 2c897e5db4e1
Step 7 : CMD ./connectivity-container
 ---> Running in b33dcbfe0997
 ---> c75e3ebfb9d8
Removing intermediate container b33dcbfe0997
Successfully built c75e3ebfb9d8
➜  connectivity-container git:(master) ✗ docker images | grep connectivity-container
connectivity-container                               alpine3.8           6a60b692575c        40 seconds ago      10.1 MB
➜  connectivity-container git:(master) ✗
➜  connectivity-container git:(master) ✗ docker save -o connectivity-container-alpine3.8.tar connectivity-container:alpine3.8
➜  connectivity-container git:(master) ✗ tar zcf connectivity-container-alpine3.8.tar.gz connectivity-container-alpine3.8.tar
➜  connectivity-container git:(master) ✗
```

* done.

# Response example
## 1. Curl from host
```
➜  connectivity-container git:(master) ✗ curl localhost:8028
{ 'Time': 'Wed, 12 Sep 2018 08:31:04 UTC','RequestURI': '/','Host': 'localhost:8028', 'UserAgent': 'curl/7.29.0' }#➜  connectivity-container git:(master) ✗
```

## 2. Curl from POD
```
 ⚡ root@k8s  /paasdata/gopath/src/k8s.io  kubectl version
Client Version: version.Info{Major:"1", Minor:"10", GitVersion:"v1.10.7", GitCommit:"0c38c362511b20a098d7cd855f1314dad92c2780", GitTreeState:"archive", BuildDate:"2018-08-21T02:53:11Z", GoVersion:"go1.10.3", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"10", GitVersion:"v1.10.7", GitCommit:"0c38c362511b20a098d7cd855f1314dad92c2780", GitTreeState:"archive", BuildDate:"2018-08-21T02:53:11Z", GoVersion:"go1.10.3", Compiler:"gc", Platform:"linux/amd64"}
 ⚡ root@k8s  /paasdata/gopath/src/k8s.io  kubectl get pod -o wide | grep connectivity-container
connectivity-container-69459d58f5-c8fgr   1/1       Running   0          16h       172.17.0.5   192.165.1.72
connectivity-container-69459d58f5-n7zjw   1/1       Running   0          16h       172.17.0.6   192.165.1.72
 ⚡ root@k8s  /paasdata/gopath/src/k8s.io  kubectl exec -ti connectivity-container-69459d58f5-c8fgr -- /bin/sh
~ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
61: eth0@if62: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP
    link/ether 02:42:ac:11:00:05 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.5/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe11:5/64 scope link
       valid_lft forever preferred_lft forever
~ # curl 172.17.0.6:8028/lalala
{ 'Time': 'Thu, 13 Sep 2018 01:38:03 UTC','RequestURI': '/lalala','Host': '172.17.0.6:8028', 'UserAgent': 'curl/7.61.1' }~ #
~ # cat /etc/os-release
NAME="Alpine Linux"
ID=alpine
VERSION_ID=3.8.1
PRETTY_NAME="Alpine Linux v3.8"
HOME_URL="http://alpinelinux.org"
BUG_REPORT_URL="http://bugs.alpinelinux.org"
~ # exit
 ⚡ root@k8s  /paasdata/gopath/src/k8s.io 
```