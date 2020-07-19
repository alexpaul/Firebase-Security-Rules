# Firebase-Rules

Setting up Firebase Rules. 

## Objective 

* Create a Firebase Project. 
* Review on what are Firebase Rules. 
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

## 1. Create a Firebase Project 

Go to [Firebase console](https://console.firebase.google.com/u/0/) and create a new project. 

## 2. Create an Xcode Project 

Create a new Xcode project called **BBQMeetup**. 

## 3. Add the necessary Firebase Pods

Add the following pods: 

```ruby 
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
```

## 4. Configure your Xcode project and Firebase 

```swift 
import Firebase 

class AppDelegate {
  func applicationDidFinishLaunching() {
    FirebaseApp.configure() 
  }
}
```

## 5. Configure Firebase Authentication

Setup sign in method to be email and password. 


## 6. Configure Firebase Firestore

Create the Firebase firestore database and setup the default rules. Choose production rules we will furhter configure the rules below.  

#### Setup the rules 

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

## Resources 

[Firebase Seurity Rules](https://firebase.google.com/docs/rules)
