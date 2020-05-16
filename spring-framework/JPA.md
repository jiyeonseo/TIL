# JPA

[`data class`](https://kotlinlang.org/docs/reference/data-classes.html#data-classes)를 사용할 수 있다. 

```sql
CREATE TABLE `User` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
) 
```

```Kotlin
package com.example.domain

import javax.persistence.*

@Entity
@Table(name="User")
data class User(
    @Id @GeneratedValue(strategy= GenerationType.IDENTITY)
    val id: Int = 0,
    
    @Column(name="name") // 컬럼 네임과 같다면 생략 가능 
    val name: String
) {
}
```

## Foreign Key 

## Composite Key 

