# build.gradle.kt 설정

## bootRun시 Profile 설정
```Kotlin
val bootRun: org.springframework.boot.gradle.tasks.run.BootRun by tasks
bootRun.apply {
	// (ex) ./gradlew bootRun -Pprofile=dev
	val profile = project.findProperty("profile") ?: "default"
	setJvmArgs(listOf("-Dspring.profiles.active=$profile"))
}
```

## Profile 별로 다른 properties 

- `application-{profile}.properties`
```
spring.profiles.active=dev
```

- `application.yml` yaml 파일 사용시 
```
spring:
  profiles:
    active: default
server:
  port: 8080
---

spring:
  profiles: dev
server:
  port: 8081
  
```

## Profile 별로 Resource가 다른 Path로

```Kotlin
val Project.profile get() = findProperty("profile") ?: "default"

sourceSets {
	main {
		resources.srcDirs(listOf("src/main/resources", "src/main/resources-$profile"))
	}
}
```

이 경우 파일은 다음과 같은 구조로 
```
.
├── kotlin
│ 
├── resources
│   ├── application.yml
├── resources-beta
│   └── application.yml
├── resources-dev
│   └── application.yml
└── resources-real
    └── application.yml
```

Jar로 실행시, 
```sh
$ java -Dspring.profiles.active=real -jar build/app.jar 
```
