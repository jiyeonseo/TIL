## devServer
- `vue-cli-service serve` 로 뜨는 개발용으로 쓰는 서버 설정 

```js 
 devServer: {
    port: devServerPort, 
    open: true,
    overlay: {
      warnings: false,
      errors: true
    },
    progress: false,
    proxy: {
      '/api' : {
        target:  'http://localhost:8080',
        changeOrigin: true,      
      }
    }
  },
```
### proxy 
- 프론트와 API 포트가 달라서 CORS 문제가 날때 사용 할 수 있다 
- 위의 설정에서는 
  - `/api` 로 들어오는 요청은 `http://localhost:8080`으로 프록시 연결하며 
  - `Origin`을 바꿔준다 

reference : https://cli.vuejs.org/config/#devserver
