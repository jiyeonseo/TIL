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

