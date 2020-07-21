# Firebase Security Rules

## Objective 

* Review what are Firebase Security Rules. 
* Configure various Firebase rules based on business logic. 

## Installation 

This repo has an included `Google-Info.plist` file for public access which allows multiple users to be on the same Firebase app. However feel free to create your own Firebase console project and download the associated `Google-Info.plist` to test security rules. 

## Firebase Rules 

Firebase rules has a similar structure to Javascript and JSON. It's a language based on the [Common Expression Language (CEL)]() that uses `match` and `allow` statements that support conditionally granted access. 

## An example use case 

In an app you may want to allow a blogger to **delete** their post from a feed but prevent another blogger from accidentally deleting that post. This is where Firebase security rules shines. It's fine to write this rule in the client app but it's best practice to have this login on your server, in this case Firebase Firestore or Firebase storage.

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

## 1. Security Rules 

Firebase security rules allow read, write access and data validation of Firebase Firestore and Firebase Storage. 

## Document access functions: 

#### Read
1. get 
2. list 

#### Write 
1. create 
2. delete 
3. update


## 2. Some request and resource rules examples 

**request**: the data being sent up to Firebase by the client app. 

**resource**: the data as it exists on Firebase. 

#### 1. Make sure the user is authenticated 

```javascipt 
request.auth != null 
```

#### 2. Get the user id 

```javascipt 
request.auth.uid
```

#### 3. Access the price property on a docuemnt

```javascipt 
request.resource.data.price
```

#### 4. Validate cohort is between 4 and 6

```javascipt 
request.resource.data.cohort >= 4 && request.resource.data.cohort <= 6
```

#### 5. Validate price is a number

```javascipt 
request.resource.data.price is number
```

#### 6. Validate name is a string 

```javascipt 
request.resource.data.name is string
```

#### 7. Validate itemName is longer than 2 characters 

```javascipt 
request.resource.data.itemName.size() > 2
```

#### 8. Vallidate reviewerId is the same as the user id 

```javascipt 
request.resource.data.reviewerId == request.auth.uid
```

#### 9. Only allow read if the document is published or the creator of the document is the one viewing it

```javascipt 
allow read: if resource.data.published == "published" || resource.data.reviewerId == request.auth.uid
```


## 3. Rule: no one can read or write to the database

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

Xcode console error
```
Missing or insufficient permissions.
```

## 4. Rule: only authentication users can read or write to database 

```javascript 
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth.uid != null;
    }
  }
}
```

> Anyone that's authenticated can read and write to any document and collection. 

## 5. Rule: only user that created content is allowed to delete it 

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
  	// people collections
  	match /people/{person} {
    	allow read, write: if request.auth.uid != null; 
    }
  	// items collection
    match /items/{item} {
    	allow read, create: if request.auth.uid != null;
      // this will ONLY allow the user that created an item to delete it 
      // resourse.data is the dictionary { json } object sent up to Firebase
      allow delete: if request.auth.uid == resource.data.personId;
    }
  }
}
```

## 6. Rule: allow a non-account user to explore the app 

```javascript 
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
  	// people collections
  	match /people/{person} {
    	allow read, write: if request.auth.uid != null; 
    }
  	// items collection
    match /items/{item} {
    	// allow non-account users to explore, they can ONLY read 
    	allow read: if true; 
      // can ONLY create an item if you an authenticated user
      allow create: if request.auth.uid != null;
      // this will ONLY allow the user that created an item to delete it 
      // resourse.data is the dictionary { json } object sent up to Firebase
      allow delete: if request.auth.uid == resource.data.personId;
    }
  }
}
```

## 7. Data validation 

```javascript 
// data validation - assure name is longer that 2 characters
allow create: if request.auth.uid != null && request.resource.data.name.size() > 2;
```

## 8. Rules for the BBQMeetup app 

```javascript
rules_version = '2';
service cloud.firestore {
    // people collections
    match /people/{person} {
      // 1
      allow read, write: if request.auth.uid != null; 
    }
    // items collection
    match /items/{item} {
      // 2
      allow read: if true; 
      // 3
      allow create: if request.auth.uid != null 
        && request.resource.data.name.size() > 2;
      // 4
      allow delete: if request.auth.uid == resource.data.personId;
    }
  }
}
```

1. **alllow** read, write access to the people collection to ONLY authentication users.
2. **allow** non-authenticated users can ONLY read from the `items` collection. 
3. **allow** create access to ONLY authenticated users and the item name has to be longer than 2 characters. 
4. **alllow** delete of an item ONLY to the person who created it. 

> More rules can be implemented above such as no delete of a person document, or only the account creator can delete a document. Rules provide robust security for your application so fully review business logic and use cases for your Firebase rules. 

## Resources 

1. [Firesbase Security Rules](https://firebase.google.com/docs/rules)
2. [Firebasse Video - Security Rules](https://www.youtube.com/watch?v=eW5MdE3ZcAw)

