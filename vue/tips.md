## bind(this)

다른 scope 함수 에서 this.$ref 사용시. 예를 들어, FileReader를 사용하여 특정 ref에 넣으려 할때 다음과 같이 하게되면 `Uncaught TypeError: Cannot read property 'preview' of undefined` 에러가 난다. 

```js
const fr =  new FileReader(); 
fr.onload = function () {
  this.$refs.preview.src = fr.result;
}
fr.readAsDataURL(file.raw);
```

지금 $ref가 있는 this를 바인딩해준다.  

```js
fr.onload = function () {
  this.$refs.preview.src = fr.result;
}.bind(this)
```
