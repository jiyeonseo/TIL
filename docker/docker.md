# Docker 
## vm과 도커 다른점 

- 따로 하이퍼바이저를 거치지 않아 성능손실이 적음 
- 컨테이너에 필요한 커널을 호스트의 커널과 공유 : 이미지 용량이 줄어듬 

## 도커 장점 

###  개발과 배포가 편함 
- 독립된 호스트 OS에 격리된 환경을 제공. 필요한 패키지만 깔면 됨. 
- 컨테이너 복사하여 다른 환경에 다시 돌릴 수 있음. 
- 이미지는 레이어 단위로 구성되어 중복되는 레이어는 캐시가 되어 배포 속도가 빨라짐. 

### 독립성과 확장성
- 특히 마이크로서비스에 용의함 
  - 여러 독립적인 모듈을 빠르게 대응해야함. 
  - 언어나 환경에 종속되지 않는 도커  

## 도커 설치 
- 도커는 리눅스 컨테이너를 제어하는 API가 Go로 구현한 libcontainer 사용 - 리눅스 운영체재 대부분에서 사용 가능. 
- EE (Enterprise Edition), CE (Community Edition) 
- [get-docker](https://docs.docker.com/get-docker/) 에서 운영체제에 맞게 
  - Windows, Mac OS에서는 가상화 공간이 별도로 필요
  - Mac OS 기준, [Docker Desktop for Mac (macOS)](https://docs.docker.com/docker-for-mac/install/) 깔면 된다.
    - 만약, 기존에 Docker Toolbox가 이미 깔려있는 머신이라면 [이 글](https://docs.docker.com/docker-for-mac/docker-toolbox/)을 먼저 참고하는 것이 좋다. 
    - 큰 차이는, Toolbox는 "리눅스 가상 머신 + 도커 컨테이너" 이기 때문에 컨테이너 접근을 위해서는 2번의 포트 포워딩 필요.
    - Docker Desktop for Mac은 호스트 자체 가상화(리눅스 가상화 ㄴ)로 도커 컨테이너 생성시 포트 포워딩 설정으로도 외부에서 접근 가능 
 
# Docker image 
- 컨테이너를 만들 때 필요.
- 여러 계층의 바이너리 파일, 컨테이너를 생성하고 실행 할때 읽는용
- 이미지 이름 : `{저장소이름}/{이미지 이름}:{태그}` 
  - 저장소 이름은 생략되면 docker hub로 

# Docker Container
- 컨테이너 각각 목적에 맞는 파일로만 구성하여 격리된 시스템 자원 및 네트워크 사용. 예를 들어, 하둡, 스파크, MySQL 등
- 하나의 이미지로 여러개의 컨테이너 (1:N)
- Container는 읽기 전용임으로, Container 에서의 수정은 Docker Image나 호스트에 영향이 가지 않음. 
