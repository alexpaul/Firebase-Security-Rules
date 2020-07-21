# Firebase-Rules

Setting up Firebase Rules. 

## Objective 

* Create a Firebase Project. 
* Review what are Firebase Security Rules. 
* Configure various Firebase rules based on business logic. 

## 0. Firebase Rules 

Firebase rules has a similar structure to Javascript and JSON. It's a language based on the [Common Expression Language (CEL)]() that uses `match` and `allow` statements that support conditionally granted access. 

#### Basic structure 

```javascript 
service <<name>> {
  // Match the resource path.
  match <<path>> {
    // Allow the request if the following conditions are true.
    allow <<methods>> : if <<condition>>
  }
}
```
