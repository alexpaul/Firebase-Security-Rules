## Security Rules 

Firebase security rules allow read, write access and data validation to Firebase Firestore and Firebase Storage. 

## Document access: 

#### Read
1. get 
2. list 

#### Write 
1. create 
2. delete 
3. update


## Request and Resource samples 

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


## 1. Rule: no one can read or write to the database

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

## 2. Rule: only authentication users can read or write to database 

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

## 3. Rule: only user that created content is allowed to delete it 

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

## 4. Rule: allow a non-account user to explore the app 

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

## 5. Data validation 

```javascript 
// data validation - assure name is longer that 2 characters
allow create: if request.auth.uid != null && request.resource.data.name.size() > 2;
```

## 6. Final rules for the BBQMeetup app 

```javascript
rules_version = '2';
service cloud.firestore {
  	// people collections
  	match /people/{person} {
    	allow read, write: if request.auth.uid != null; 
    }
  	// items collection
    match /items/{item} {
    	// allow non-account users to explore, they can ONLY read 
    	allow read: if true; 
      // can ONLY create an item if you an authenticated user
      // data validation - assure name is longer that 2 characters
      allow create: if request.auth.uid != null 
      	&& request.resource.data.name.size() > 2;
      // this will ONLY allow the user that created an item to delete it 
      // resourse.data is the dictionary { json } object sent up to Firebase
      allow delete: if request.auth.uid == resource.data.personId;
    }
  }
}
```

## Resources 

1. [Firesbase Security Rules](https://firebase.google.com/docs/rules)
2. [Firebasse Video - Security Rules](https://www.youtube.com/watch?v=eW5MdE3ZcAw)
