# Docker Basic CLI

## --version 
```sh
docker -v 
Docker version 19.03.8, build afacb8b
```

## docker run
```sh
docker run -i -t ubuntu:latest # or docker run -it ubuntu:latest
```
- `-i` : interactive
- `-t` : tty 활성화 
- `ubuntu:latest` : docker hubdㅔ 있는 ubuntu에서 가장 최신 태그. 로컬에 없을경우 바로 pull 해옴 
  - `pull` > `create` > `start` > `attach`  
- 밖으로 빠져나올 때 
  - `exit` or `Ctrl+D` : 컨테이너를 정지 
  - `Ctrl+P` or `Ctrl+Q` : 컨테이너 run은 그대로되 나만 빠져나오는 방법. (실서비스 운영시 사용)  

## docker pull
```sh
docker pull centos:7
```

## docker images
```sh
docker images
```
로컬에 있는 이미지 리스트를 전체 보여줌 
```sh
REPOSITORY                                     TAG                   IMAGE ID            CREATED             SIZE
ubuntu                                         latest                1d622ef86b13        13 days ago         73.9MB
```
 
## docker create 
```sh
docker create -i -t --name thisismine ubuntu:latest
79ad8354223afecdfd61958524286b5b0ee3fe47763b74904e4ba8f39ff3c102
```
- 컨테이너 생성. 아직 실행 ㄴㄴ 

## docker start 
```sh
docker start thisismine
```
- 도커 컨테이너 시작 with name

## docker attach 
```sh
docker attach thisismine
```
- 도커 컨테이너 interative mode with name. 위 `-it`와 같음. `exit`으로 나오면 컨테이너 종료.

## docker ps 
```
docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                         PORTS                    NAMES
ad236d70f099        ubuntu:latest       "/bin/bash"              5 minutes ago       Up 2 seconds                                            thisismine
```
- 실행중인(exit하지 않은) 컨테이너 리스트 
- 정지된 컨테이너까지 보려면 `-a` 

```sh 
docker ps -a
```
  - `CONTAINER ID` : 고유 ID. 
```sh
# 전체 ID는 아래와 같이 찾을 수 있다. 
docker inspect thisismine | grep Id
        "Id": "ad236d70f09993e45794d3403ea029565083787c4c29c0bc35efa47a8075f9b6",
```
  - `COMMAND` : 시작될때 실행될 명령어.
```
docker run -it ubuntu:latest echo hey there
# echo hey there < 이 명령어가 들어감. 다만 이 경우, /bin/bash가 echo로 덮어씌워져 echo만 실행하고 컨테이너는 종료됨. 
```

  - `STATUS` : 실행 중이면 `Up`. 정지되면 `Exited (0) 16 minutes ago` 이런식으로.  
  - `PORT` : 외부와 통신시 연결 필요. 
  - `NAME` : --name 옵션으로. default는 "{형용사}_{명사}" 랜덤 조합. rename 가능
```
docker rename thisismine my_container
```

### --format 
```
docker ps --format "table {{.ID}}\t{{.Names}}"
CONTAINER ID        NAMES
ad236d70f099        my_container
```

## docker rm 
```sh
docker rm my_container
```
- exited 된 경우가 아니라면 `Error response from daemon: You cannot remove a running container {Container ID}. Stop the container before attempting removal or force remove`와 같은 에러가 남.
```sh 
docker stop my_container # stop 먼저
# 혹은 
docker rm -f my_container # --force 
```

## docker container prune
```
docker container prune
WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N] 
```
- 생성한 컨테이너 모두 삭제하기 

혹은 `ps -a -q` (`-q`는 컨테이너 아이디만 가져오기) 를 이용하여 
```sh
docker rm -f $(docker ps -a -q)
```

## -p
- 가상 IP 주소와 외부 포트로 연결.
- `172.17.0.x` 순차적으로 IP 할당. -> 내부에 들어가서 `ifconfig` 
```
docker run -p 80:80 ubuntu:14.04 # [host port]:[container port] 
docker run -p 3306:3306 -p 192.168.0.100:7777:80 ubuntu:14.04
```







