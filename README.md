# Firebase-Rules

Setting up Firebase Rules. 

## Objective 

* Create a Firebase Project. 
* Review on what are Firebase Rules. 
* Configure various Firebase rules based on business logic. 

## 1. Create a Firebase Project 

Go to [Firebase console](https://console.firebase.google.com/u/0/) and create a new project. 

## 2. Create an Xcode Project 

Create a new Xcode project called **BBQ**. 

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

Create the Firebase firestore database and setup the default rules. Choose production we will configure below.  

#### Setup the rules 

```json
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```
