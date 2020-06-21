# 도커 컴포즈 
- 여러 컨테이너를 각각 생성하면 번거러움 
- 여러개의 컨테이너를 하나의 서비스로 정의해 컨테이너 묶음으로 관리 

## 설치 
- [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

```sh 
# linux 기준
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
$ docker-compose -v # 버전확인 
```

- Mac OS 의 경우 docker for Mac 에 함께 설치됨. 

## 설정파일 (docker-compose.yml)

```yaml
version: '3.0' # YAML 파일 포맷의 버전 - https://github.com/docker/docker.github.io/blob/master/compose/compose-file/compose-versioning.md#versioning 

services: # 생설될 컨테이너들을 묶어놓는 단위. 
  web: # 생성될 서비스의 이름. 
    container_name: services_web_1 # default name : [프로젝트 이름]_[서비스 이름]_[서비스내 컨테이너 번호]
    image: web:test 
    ports:
      - "80:80"
    links:
      - mysql:db
    command: apachetl -DFOREGROUND
  mysql:
    image: mysql:latest
    command: mysqld
```


```sh 
# 실행 
$ docker-compose up -d # 따로 설정 안하면 현재 디렉토리의 docker-compose.yml 파일 읽음.

# 컨테이너 확인 
$ docker-compose ps 
Name   Command   State   Ports
------------------------------

# mysql 컨테이너는 2개로!
$ docker-compose scale mysql=2 

# docker-compose 내 컨테이너 중 web 띄우기 
$ docker-compose run web /bin/bash

# 컨테이너 정지 및 삭제 
$ docker-compose down
```

### -p
- 프로젝트 이름 명시 

```sh
$ docker-compose -p myproject up -d 
$ docker-compose -p myproject down
```

### -f 
- 파일 지정 
```sh
$ docker-compose -f /home/cheese/private/my_docker_compose.yml up -d 
```
- `-f`로 먼저 파일 지정, 그 후 `-p`로 프로젝트 이름 명시 

## services 설정 
### image 
- `docker run` 과 동일. 이미지 없으면 pull

### links 
- `docker run --link`과 동일. 서비스 명으로 접근할수 있도록 설정 

### environment
- `docker run --env`, `docker run -e` 

```yaml
services:
  web:
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE_NAME=dbname
    # OR
    environment:
      - MYSQL_ROOT_PASSWORD:password
      - MYSQL_DATABASE_NAME:dbname
```

### depends_on
- 컨테이너 의존 관계. 명시된 컨테이너가 먼저 생성되고 실행.
```yaml
services:
  web:
    depends_on:
      - mysql
```
만약 의존성 없이 컨테이너를 생성하려면 

```sh
$ docker-compose up --no-deps web
```

- 실행 순서만 보장할 뿐, 실제 어플리케이션이 준비되었는지는 알 수 없음. 
  - `endpoint` 의 쉘스크립트를 이용하여 체크하여 실행하는 방법도 있음.

```yaml
services:
  web:
    endpoint: ./endpoint.sh mysql:3306
```

```sh
# ./endpoint.sh 
until (상태체크); do
  sleep 1
done 

(어플리케이션 실행) 
```
### ports 
```yaml
services:
  web:
    ports:
    - "8080"
    - "8081-8085"
    - "80:80" # 단일 호스트 환경 - scale 안됨
```

### build
- `build`에 정의된 도커파일을 빌드해서 서비스 컨테이너를 생성하도록 
```yaml
services:
  web:
    build: ./composetest # 이 디렉토리에 있는 dockerfile 을 빌드해서 
    image: cheese/composetest:web  # 이 이미지 이름으로 
```
- `docker-compose up` 때마다 빌드하려면 `--build` 인자를 추가해 주어야함 
```sh
$ docker-compose up -d --build
$ docker-compose build {서비스 이름}
```

### extends 
- 다른 yaml 파일이나 현재 yaml 파일에서 서비스 속성을 상속받게 설정. 
```yaml
# docker-compose.yml
services:
  web:
    extends:
      file: extend_compose.yml
      service: extend_web
      
      
# extend_compose.yml
version: '3.0'

services:
  extend_web:
    image: ubuntu:latest
    ports: 
      - "80:80"
```

##  네트워크 
  
### driver 
-  default : 브릿지 타입 네트워크
```
services:
  myservice:
    image: nginx
    networks: 
      - mynetwork
networks:
  mynetwork:
    driver: overlay # 드라이버 타입 
    driver_opts: # driver에 필요한 옵션들 
      subnet: “255.255.255.0”
      IPAddress: “10.0.0.2”
```

### ipam
- IPAM(IP Address Manager) 를 사용하는 옵션 
```
networks:
  ipam:
    driver: mydriver
    config:
      subnet: 172.20.0.0/16
      ip_range: 172.20.5.0/24
      gateway:  172.20.5.1
```

### external 
- 기존의 네트워크를 사용하려 할때 
```
services:
  web:
    image: web:lastest
    networks: my_network
networks:
  my_network:
    external: true
```

## 볼륨

### driver
- 볼륨 생성에 사용할 드라이버 
- default: local 
- driver_opts 로 추가 옵션 가능 
```
volumes: 
  driver: flocker
  driver_opts:
    opt: “1”
    opt2: “2”
```

### external 
- 기존 볼륨 사용할때 
```
services:
  web: 
    image: web:latest
    volumes:
      -myvolume:/var/www/html
volumes:
  myvolume:
    external: true
```

## YAML 파일 검증 
```sh
$ docker-compose config 
$ docker-compose config -f {yml 파일 경로}
```

## 도커 컴포즈 네트워크 
- scale을 통해 여러 컨테이너로 떠 있는 경우. 호스트로 접근하면 컨테이너 중 하나가 ip로 변환됨. (라운드로빈)





