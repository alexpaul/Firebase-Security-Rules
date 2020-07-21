# Creating the BBQMeetup app

## 1. Create an Xcode Project 

Create a new Xcode project called **BBQMeetup**. 

## 2. Create a Firebase Project 

Go to [Firebase console](https://console.firebase.google.com/u/0/) and create a new project. 

1. Create and configure an iOS app in your Firebase project. 
2. Register the iOS app using the bundle identifier from your Xcode project. 
3. Download the `Google-Info.plist` file. 
4. Add the `Google-Info.plist` to the Xcode project.

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

The rules below won't allow reading or writing from the database. 

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

## 7. Add the following asychronous test - FirebaseAuthenticationTests

#### Add a Unit Test Target if one doesn't exist and create asynchronous tests for the following: 

1. Create an authenticated user. 
2. Sign out a user. 
3. Sign in a user. 

#### 1. Create an authenticated user.

```swift
func testCreateAuthUser() {
  // arrange
  let email = getRandomEmail()
  let password = "123456"
  let exp = XCTestExpectation(description: "auth user created")
  // act
  Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
    // assert
    exp.fulfill()
    if let error = error {
      XCTFail("failed to create user with error: \(error.localizedDescription)")
    }
    XCTAssertEqual(authDataResult?.user.email, email)
  }
  wait(for: [exp], timeout: 3.0)
}

private func getRandomEmail() -> String {
  let randomLength = Int.random(in: 5...10)
  let domains = ["gmail", "appple", "pursuit", "yahoo", "test", "hotmail"]
  let lettersAndNumbers = "abcdefghijklmnopqrstuvwxyz1234567890".map { String($0) }
  var name = ""
  for _ in 0..<randomLength {
    name.append(lettersAndNumbers.randomElement() ?? "")
  }
  return "\(name)@\(domains.randomElement()!).com"
}
```

#### 2. Sign out an authenticated user.

```swift 
func testSignOutUser() {
  do {
    try Auth.auth().signOut()
    XCTAssert(true)
  } catch {
    XCTFail("failed to sign out user with error: \(error.localizedDescription)")
  }
}
```

#### 3. Sign in an authenticated user. 

```swift 
func testSignInUser() {
  // arrange
  let email = "1r5dn@hotmail.com"
  let password = "123456"
  let exp = XCTestExpectation(description: "did sign in user")
  // act
  Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
    exp.fulfill()
    // assert
    if let error = error {
      XCTFail("failed to sign in user with error: \(error.localizedDescription)")
    }
    XCTAssertEqual(email, authDataResult?.user.email)
  }
  wait(for: [exp], timeout: 3.0)
}
```

## 8. Add the following asychronous test - FirebaseAuthenticationTests

#### 1. Create an asynchronous test to create a person document in the people collection

```swift 
func testCreatePersonInPeopleCollection() {
  // arrange
  let nameEmail = getRandomEmail()
  let password = "123456"
  let exp = XCTestExpectation(description: "auth user created")
  let collectionName = "people"
  let personId = UUID().uuidString
  let personDict: [String: Any] = ["name": nameEmail.name,
                                   "connection": getRandomEmail().name,
                                   "personId": personId,
                                   "email": nameEmail.email
  ]
  // act
  Auth.auth().createUser(withEmail: nameEmail.email, password: password) { (authDataResult, error) in
    if let error = error {
      XCTFail("failed to create auth user with error: \(error.localizedDescription)")
    }
    Firestore.firestore().collection(collectionName).document(personId).setData(personDict) { (error) in
      exp.fulfill()
      if let error = error {
        XCTFail("failed to create person in people collection with error: \(error.localizedDescription)")
      }
      XCTAssert(true)
    }
  }
  wait(for: [exp], timeout: 5.0)
}

private func getRandomEmail() -> (name: String, email: String) {
  let randomLength = Int.random(in: 5...10)
  let domains = ["gmail", "appple", "pursuit", "yahoo", "test", "hotmail"]
  let lettersAndNumbers = "abcdefghijklmnopqrstuvwxyz1234567890".map { String($0) }
  var name = ""
  for _ in 0..<randomLength {
    name.append(lettersAndNumbers.randomElement() ?? "")
  }
  return (name, "\(name)@\(domains.randomElement()!).com")
}
```

#### 2. Create an asynchronous test to create an item document in the items collection

```swift 
func testAddItemForLoggedInUser() {
  // arrange
  enum ItemType: String, CaseIterable {
    case seafood
    case drink
    case meat
    case game
    case dessert
  }

  let collectionName = "items"
  let exp = XCTestExpectation(description: "item added")
  guard let user = Auth.auth().currentUser else { return }
  let itemId = UUID().uuidString
  let itemDict: [String: Any] = ["name": "Grilled Salmon",
                                 "type": ItemType.seafood.rawValue,
                                 "personId": user.uid,
                                 "servings": 4,
                                 "itemId": itemId
  ]
  // act
  Firestore.firestore().collection(collectionName).document(itemId).setData(itemDict) { (error) in
    // assert
    exp.fulfill()
    if let error = error {
      XCTFail("failed to add item with error: \(error.localizedDescription)")
    }
    XCTAssert(true)
  }
  wait(for: [exp], timeout: 3.0)
}
```


## Resources 

[Firebase Security Rules](https://firebase.google.com/docs/rules)
