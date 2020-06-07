# Github Action 

## Templates 
- javacscript : [https://github.com/actions/javascript-action](https://github.com/actions/javascript-action) 


- Action 파일 위치 : `.github/workflows/action.yml`

## 문법 
```yaml
name: {action_name}
on:
  schedule:
    - cron: '0 7 * * *' # Every day at 7am

jobs:
  {job_name}: 
    name: {job_display_name} # Actions 탭에서 보이는 이름
    runs-on: ubuntu-latest
    steps:
      - name: {step_name} # 스탭 이름 
        uses: jiyeonseo/daily-hackernews-action@v1.2 # 사용할 액션 
        with: # 변수들 
          chat_id: "1077870607" 
          coount: 5
          telegram_key: ${{ secrets.TELEGRAM_KEY }} # Github > repo > settings > secrets 에 설정한 값 
```

## Trigger 방법 

### schedule 

```yaml
on:
  schedule:
    - cron:  '*/15 * * * *'
```
- `* * * *` : 매 분 마다
- `0 7 * * *` : 매일 7am (UTC 기준) 
- `0 4-6 * * *` : 매 4,5,6시 0분(정각)마다 


### watch 

```yaml 
on:
  watch:
    types: [started] # repo가 스타 받았을 때 
```
- `started` : Repo 에 스타받았을 때 (디버깅때 이용하면 편함)

references : https://help.github.com/en/actions/reference/events-that-trigger-workflows 

## Samples 
- [daily-hackernews-action](https://github.com/jiyeonseo/daily-hackernews-action) : 🗞 Daily top hackernews stories with Github Action & Telegram  
