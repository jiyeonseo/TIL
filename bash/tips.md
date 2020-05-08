## 현재 위치로 VS Code 열기 

### 설정
```sh
# .bashrc 
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}
```

### 사용 
```sh
$ code .
```

## nohup과 &

### nohup
- to ignore the HUP (hangup) signal
- 세션이 끊겨도 계속 실행 되도록 

### & 
- 백그라운드에서 돌도록 

```sh
nohup sh abc.sh & 
```

### 로그파일 

기본적으로 `nohup.out`

```sh
nohup sh abc.sh > /dev/null 2>&1 & # without nohup.out
nohup sh abc.sh > custom_log.log 2>&1 & ## logfile 지정하기 
```
