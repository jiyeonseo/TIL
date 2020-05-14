# Python virtualenv

## Installation 

```sh 
pip install virtualenv 
# or 
pip3 install virtualenv
```

## Activate 
```sh
mkdir demo && cd demo 
virtualenv venv
source venv/bin/activate
```

## Automation to activate 
```sh
# .bashrc

function cd() { 
  if [[ -d ./venv ]] ; then
    deactivate
  fi

  builtin cd $1

  if [[ -d ./venv ]] ; then  
    . ./venv/bin/activate
  fi
}
```

reference : [python virtualenv 사용하는 프로젝트 들어갈 때 자동으로 activate 시키기](https://jiyeonseo.github.io/2020/02/16/bashrc-tips/#python-virtualenv-%EC%82%AC%EC%9A%A9%ED%95%98%EB%8A%94-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EB%93%A4%EC%96%B4%EA%B0%88-%EB%95%8C-%EC%9E%90%EB%8F%99%EC%9C%BC%EB%A1%9C-activate-%EC%8B%9C%ED%82%A4%EA%B8%B0)
