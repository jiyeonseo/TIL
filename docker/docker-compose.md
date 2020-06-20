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
```




