## devServer
- `vue-cli-service serve` 로 뜨는 개발용으로 쓰는 서버 설정 

```js 
 devServer: {
    port: 3000, 
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
- 개발상황에서는 프론트와 API 서버 및 포트가 다르다 
  - 그대로 `/api` 로 요청하면 서버API가 아님으로 404 
  - API 서버로 그대로 요청하면 CORS 문제가 발생한다 
- 위의 설정에서는 
  - `/api` 로 들어오는 요청은 `http://localhost:8080`으로 프록시 연결하며 
  - `Origin`을 바꿔준다 
```
http://localhost:3000/api/foo -> http://localhost:8080/api/foo
```
reference : https://cli.vuejs.org/config/#devserver
