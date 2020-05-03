## SAML 

- Security Assertion Markup Language 
- 네트워크 내의 인증(Authentication)과 권한 부여(Authorization)데이터를 교환하기 위한 XML 표준
- SSO 구현의 기반이 됨

### 장점 
- 서비스마다의 로그인을 하지 않아도 됨
- 인증 위임
- 인증/권한부여 보호 

### v1.1과 v2.0의 차이점 
- v2.0은 2005년에 도입되어 v1.1은 거의 사용되고 있지 않음.  
- https://wiki.shibboleth.net/confluence/display/SHIB/SAMLDiffs 

### 주요 원리 

![saml_explainer](https://github.com/jiyeonseo/TIL/blob/master/term/security-assertion-markup-language-saml-explainer-100738529-orig.jpg)

- Service Provider : 접근하려는 서비스 혹은 어플리케이션 
- idp : Identity Provider. 사용자 credential(ID/PW) 인증하고 SAML assertion 발행 


### 실 사용 예제 

![slack_with_SAML](https://github.com/jiyeonseo/TIL/blob/master/term/Sign_in_with_SAML.png)

### SAML vs. oAuth 
- OAuth는 JSON 기반으로 모바일 플랫폼 위에서의 SAML 결함을 보완하기 위해 개발됨. 
- OAuth는 권한 부여(Authorization)를 위해 사용됨  

### references

- https://en.wikipedia.org/wiki/User:Trscavo/Sandbox/SAML_2.0 
- https://www.nexpert.net/606 
