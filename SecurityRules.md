## Security Rules 

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

## 3. Rule: only user that created content is allowed to delete it 

```javascript 
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
    	allow read: if request.auth.uid != null;
      allow create: if request.auth.uid != null;
      allow delete: if request.auth.uid == resource.data.personId;
    }
  }
}
```
