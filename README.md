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

## 3. Initialize CocoaPods withing the project in Terminal and add the following Firebase Pods

#### Initialize pods 

```
pod init  
```

Add the following pods to the Podfile and run `pod install`: 

```ruby 
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
```

Close your Xcode project and now open the .xcworkspace file to continue working with the BBQMeetup app. 

## 4. Configure your Xcode project and Firebase 

Add the following to the AppDelegage.swift file 

```swift 
import Firebase 

class AppDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
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

## 7. Add the following asychronous test 

#### Add a Unit Test Target and create an asynchronous test to authenticate and add a user to the users collection 

```swift 
```

#### Create an asynchronous test to add an item to the items collections 

```swift 
```

## Resources 

[Firebase Seurity Rules](https://firebase.google.com/docs/rules)
