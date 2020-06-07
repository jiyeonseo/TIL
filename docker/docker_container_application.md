# Docker container application 

- 한 컨테이너에 여러 어플리케이션 가능
- 컨테이너 간의 독립성을 보장하고 어플리케이션 각각의 버전관리, 모듈화를 위해서는 1 컨테이너 : 1 어플이 좋음. 

# 예제 만들어 보기 : mysql + 워드프레스 - 볼륨, 네트워크, 로깅,   

## mysql
```sh
$ dockr run -d \ # detached mode. 백그라운드 실행. 
  --name database \
  -e MYSQL_ROOT_PASSWORD=password \ # 환경변수 
  -e MYSQL_DATABASE=wordpress \
  mysql:5.7   # mysql tag 5.7
```

## wordpress
```sh 
$ docker run -d \
  -e WORDPRESS_DB_PASSWORD=password \
  --name wordpress \ 
  --link database:mysql \ # 위에 띄운 database 컨테이너와 연결 
  -p 80 \ # 호스트의 포트 중 하나와 컨테이너의 80이 연결됨 -> 확인하려면 docker ps 로 연결된 포트 확인. 
  wordpress 
```

- 연결된 포트만 확인하고 싶을때는 `docker port {container_name}` 해주면 `{container port} -> {host port}` 로 결과 나옴


### `-d` option

- detached mode. 백그라운드 실행
- 참고. `-i -t`  는 attach 모드. 
- `docker run -d` : 내부에서 터미널을 차지하는 foreground가 없으면 실행 즉시 어플리케이션 종료됨. 
- mysql 은 mysqld, wordpress는 apache2-foreground가 실행되므로 `-d` 사용 가능 
- foreground가 있는 컨테이너를 `docker run -i -t`으로 run 하면 실행중인 로그만 확인 가능. 

### `-e` option

- 환경변수 
- 내부에서 `$ echo $MYSQL_ROOT_PASSWORD` 하면 위의 설정값 볼 수 있음. 

### `--link` option 

- 두 컨테이너를 연결.
- 할당 받은 IP로도 가능하지만 계속 바뀌는 값을 챙겨주기 어려우니 alias로 
- link 하려는 컨테이너가 떠 있지 않으면 같이 컨테이너가 뜨지 않음. 
- deprecated 된 옵션. -> 도커 브릿지 네트워크를 사용하자. 

# Docker volumn

- 도커 이미지 : read only , 도커 컨테이너: able to write 
- 컨테이너가 삭제되면 작성한 데이터도 사라짐 -> persistent 하지 못함. 
- 볼륨을 이용 
  - 호스트와 공유
  - 볼륨 컨테이너 활용 
  - 도커가 관리하는 볼륨 
  
### 호스트 볼륨 
```sh
$ dockr run -d \ 
  --name database \
  -e MYSQL_ROOT_PASSWORD=password \ 
  -e MYSQL_DATABASE=wordpress \
  -v /home/wordpress_db:/var/lib/mysql \ # 볼륨 설정  [호스트의 공유 디렉토리]:[컨테이너의 공유 디렉토리]
  mysql:5.7   
```

- 호스트에 `/home/wordpress_db` 생성 -> 컨테이너의 `/var/lib/mysql` 복사 -> 컨테이너의 `/var/lib/mysql` 삭제

```sh
... 호스트에서
$ echo helloworld >> /home/helloworld && echo byeworld >> /home/byeworld
...
  -v /home/helloworld:/hello \
  -v /home/byeworld:/bye \
  
... # 컨테이너 내부 
$ cat hello && cat bye 
helloworld
byeworld
```
- `-v` 여러번 써서 여러 파일도 가능 

- 만약, 볼륨 설정을 하려는 dir에 이미 존재하고 있다면? -> 호스트에 원래 있던 파일들이 컨테이너의 디렉토리를 mount 시켜버린다.  


### 볼륨 컨테이너 

- `--volumes-from` 으로 다른 컨테이너의 볼륨 공유 
- 이때 다른 컨테이너의 볼륨은 `-v` 옵션을 통해 다른 볼륨을 공유 하는 것 

```sh 
$ docker run -i -t \
  --name vol_from_container \
  --volumnes-from database \ # -v /home/wordpress_db:/var/lib/mysql 이미 한 컨테이너 
  ubuntu
```


### 도커 볼륨 
```
$ docker volume create --name myvolume
myvolume

$ docker volume ls 
DRIVER              VOLUME NAME
local               myvolume

$ docker run -i -t --name myvolume_ubuntu \
  -v myvolume:/root/ \  # {volume name} : {컨테이너 공유 디렉토리}
  ubuntu:14.04
  

$ docker run -i -t --name myvolume_ubuntu2 \ # 다른 컨테이너와 공유 가능 
  -v myvolume:/root/ \ 
  ubuntu:14.04
  
$ docker inspect --type volume myvolume # 실제 어디에 있는지 확인하기 
[
    {
        "CreatedAt": "2020-06-07T08:44:41Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/myvolume/_data",
        "Name": "myvolume",
        "Options": {},
        "Scope": "local"
    }
]

# 미리 docker volumne create 안해도 자동으로 만들어줌 
$ docker run -i -t --name vol_auto  \
  -v /root \
  ubuntu:14.04
  
$ docker volume ls 
DRIVER              VOLUME NAME
local               27bd70cef27.... # 16진수 형태로 랜덤 이름 


$ docker container inspect vol_auto # 컨테이너에 대한 상세 정보 확인 

$ docker volume prune # 볼륨 모두 삭제 
```

### `mount` 
- 기능적으로는 같다. 하지만 사용법이 다르다 
```sh
$ docker run -i -t \
  --mount type=volume,source=myvolume,target=/root \
  ubuntu 
```

# 네트워크

## 네트워크 구조 
- 컨테이너가 생성될때 가상 네트워크 인터페이스를 호스트에 생성 `veth` (virtual eth) 
- 컨테이너 수만큼 호스트에서 확인 가능 `ifconfig`
- `docker0`는 `veth`들과 `eth0` 인터페이스를 연결해주는 역할 -> `brctl show docker0` 

## 도커 네트워크 
```sh
$ docker network ls 
NETWORK ID          NAME                DRIVER              SCOPE
5a88aad19402        bridge              bridge              local
21ba19f1141a        host                host                local
d77813eebcf4        none                null                local
```
- bridge : 컨테이너가 설정될때마다 자동으로 연결되는 docker0 브릿지를 사용하도록 `172.17.0.x` IP 순차적으로 할당

###  브릿지 네트워크 
- 기본 docker0 말고 사용자 정의 브릿지를 새로 생성 및 외부 통신 연결 
```
  $ docker network create --driver bridge mybridge
  
  $ docker run -i -t --name mycontainer\
    --net mybridge \ # --net {bridge name}
    ubuntu 
  
  $ docker network disconnect mybridge mycontainer # docker network disconnect {bridge} {container}
  $ docker network connect mybridge mycontainer  # docker network connect {bridge} {container}
  
  # 원하는 서브넷, 게이트웨이, IP 등 설정도 가능 
  $ docker network create --driver=bridge \
  --subnet=172.72.0.0/16 \
  --ip-range=172.72.0.0/24 \
  --gateway=172.72.0.1 \
  my_network
```

### 호스트 네트워크 
- 따로 설정하지 않고 호스트의 네트워크 환경 그대로 사용 
```sh
docker run -i -t --name host_network \
--net host \ 
ubuntu 
```
- 별도 포트 포워딩 없이 바로. 마치 호스트에서 어플리케이션 띄운것 과 같음. 

### 논 네트워크 
- 아무런 네트워크를 쓰지 않겠다 
```sh
$ docker run -i -t --name none_network \
--net none \ 
ubuntu
```

### 컨테이너 네트워크 
- 다른 컨테이너와의 네트워크 
```sh
$ docker run -i -t --name container_network \
  --net container:another_container \ # --net container:{container_name}
  ubuntu
```

### --net-alias
- 특정 호스트의 이름으로 컨테이너 여러개 접근 가능 
```sh
$ docker run --name container1 \
  --net mynetwork \
  --net-alias cheese \
  ubuntu 
  
$ docker run --name container2 \
  --net mynetwork \
  --net-alias cheese \
  ubuntu 
  
$ docker run --name container3 \
  --net mynetwork \
  --net-alias cheese \
  ubuntu 
```

- 각각의 컨테이너들을 다 다른 IP 주소를 할당 받았을 것. 
- 컨테이너 내부에서 alias로 ping 을 알려보면 3개의 컨테이너가 라운드로빈으로 전송되는 것을 확인 가능 - 도커 내장 DNS (`127.0.0.11`)
```sh 
$ ping -c 1 cheese
```


### MacVLAN 네트워크 

- 호스트의 네트워크 인터페이스 카드를 가상화 -> 물리 네트워크 환경을 컨테이너에게 제공 
- 컨테이너 : 물리 네트워크 상의 가상 MAC 주소를 가짐 
- 공유기, 라우터, 스위치 등 네트워크 장비 2대에 동일 IP 대역에 있는 서버/컨테이너들 간에 통신 가능 


```sh
# 두 장비에 다음과 같이 네트워크 설정 
$ docker network create -d macvlan \  # --driver : macvlan을 네트워크 드라이버로 사용할 것이다.
  --subnet=192.168.0.0/24 \ # --subnet 사용할 네트워크. 192.168.0.0/24 = 네트워크 장비의 IP 대역 기본 설정
  --ip-range=192.168.0.64/28 \ # 호스트에서 사용할 컨테이너 IP 범위. 두 장비가 겹치지 않도록 세팅  
  --gateway \ # 네트워크에 설정된 게이트웨이 
  -o macvlan_mode=bridge \ # 추가적인 옵션 
  -o parent=eth
  my_macvlan
```
 
# 로깅



```sh
$ docker logs mysql
$ docker logs --tail 2 mysql # 마지막 2줄만 읽기 
$ docker logs --since {unix_time} mysql # 유닉스 시간으로 특정 시간 이후 로그 확인 
$ docker logs -f -t mysql # -t 타임스탬프, -f 로그 스트림 
$ docker run \
  --log-opt max-size=10k \ # 최대 크기. default = -1(무제한)
  --log-opt max-file=3 \ # 로그 파일 개수. default = 1 
  --name log-test
  ubuntu
  
$ DOCKER_OPTS="--log-opt max-size=10k --log-opt max-file=3" #요래 설정도 가능 
```

- 기본적으로 json 형태로 도커 내부에 저장됨 

### syslog

```sh 
$ docker run \
  --log-driver=syslog \ # syslog로 세팅 -> 컨테이너 내부에 /var/log/syslog
  ubuntu 
```

- syslog를 이용하면 원격으로 중앙컨테이너에 로그 저장 가능 
```sh
# 중앙 서버 컨테이너 생성 
$ docker run \
  -p 514:514 -p 514:514/udp \
  ubuntu 
  
$ vi /etc/rsyslog.conf 

# /etc/rsyslog.conf 
... 

$ service rsyslog restart 

# 클라이언트 컨테이너 
$ docker run \
  --log-driver=syslog \ # 로깅 드라이버는 syslog
  --log-opt syslog-address=tcp://192.168.0.100:514 \ # 컨테이너에 접근할 수 있는 방법. 위에 udp도 열어놔서 udp://로 사용해도 됨.  
  --log-opt tag="mylog" \ # 로그 앞에 붙힐 태그 
  --log-opt syslog-facility="application-log" \ # 따로 파일을 만들 수 있음. application-log.log 로 
  ubuntu

```

### fluentd

- `컨테이너들` -> `fluentd` -> `몽고` case
  - 도터 fluentd 에서는 mongo plugin을 제공하고 있지 않으니 책의 저자가 만든걸 사용하자 
  
```
$ docker run -p 80:80 \
  --log-driver=fluentd \
  --log-opt fluentd-address=192.168.0.101:24224 \
  --log-opt tag=docker.nginx.webserver \
  nginx
```

### AWS 클라우드워치 로그 

```
$ docker run \
  --log-driver=awslogs \
  --log-opt awslogs-region=ap-northeast-2 \
  --log-opt awslogs-group=mygroup \
  --log-opt awslogs-stream=mylogstream \
  ubuntu
```

# 자원 할당 제한 

### 메모리 제한 
```
$ docker run -d \
  --memory="1g" \ # m : megabyte, g : gigabyte  최소메모리 4mb 
  ...
```
- 메모리 초과하면 컨테이너 종료 혹은 실행되지 않음 주의. 

### CPU 제한 
- 얼마나 쉐어할것인지 
```
$ docker run \
  --cpu-share 1024 \ # default : 1024 -> CPU 할당 1 의미  
  ubuntu 
```
- 상대적인 값. 하나만 있으면 한개가 100% 사용. 
- 다른 하나가 512의 share로 뜬다면 2:1로 나눠 씀. 

- 특정 CPU만 사용하기 
```
$ docker run \ 
  --cpuset-cpus=2 \ # index는 0부터
  ubuntu 
```

- CFS (Completely Fair Schedule) 주기 
```
$ docker run \
  --cpu-period=100000 \ # default = 100000 
  --cpu-quota=25000 \ # cpu-period의 시간중 CPU 스케줄링을 얼마나 할당할 것인지 
  ... 
  # 즉, {quota}/{period} 만틈의 CPU 시간을 할당 받는다 -> 위의 경으 1/4 
```

- CPU 갯수 
```
$ docker run \ 
  --cpus=0.5 \ # CPU 50%를 차지하겠다. 
  ... 
```

- Block I/O 제한 
  - default 는 무제한 
```
$ docker run \
  --drive-write-bps /dev/xvda:1mb \ # 초당 쓰기 최대 1MB. kb, mb, gb 단위. {device_name}:{value}
  ubuntu
  

$ docker run \
  --drive-write-iops /dev/xvda:5 \ # 상대값. 
  ubuntu
```

