## Security Rules 

Firebase security rules allows read, write access and data validations to Firestore and Storage. 

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
