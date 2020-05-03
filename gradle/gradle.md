# Gradle

## pom -> gradle.build 포팅

`pom.xml` 파일이 있는 경로에서 

```sh
$ gradle init --type pom # 혹은 gradlew init --type pom

> Task :init
Maven to Gradle conversion is an incubating feature.
Get more help with your project: https://docs.gradle.org/6.1.1/userguide/migrating_from_maven.html

BUILD SUCCESSFUL in 1s
2 actionable tasks: 1 executed, 1 up-to-date
```

reference : https://docs.gradle.org/6.1.1/userguide/migrating_from_maven.html 
