//
//  FirebaseBasedProtocol.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 08.02.2022.
//

import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import CryptoKit

// MARK: Base Protocol

protocol FirebaseBased {
    var firebaseUser: FirebaseAuth.User { get }
    var firestore: Firestore { get }
}

extension FirebaseBased {
    // FIREBASE
    // Firebase user
    var firebaseUser: FirebaseAuth.User {
        guard let user = Auth.auth().currentUser else {
            fatalError("You cant get firebase user before auth")
        }
        return user
    }
    // Firebase firestore
    var firestore: Firestore {
        Firestore.firestore()
    }
    
    // Firebase storage
    var storage: Storage {
        Storage.storage()
    }
    var storageRef: StorageReference {
        storage.reference()
    }
}

// MARK: Path Provider

extension Firestore {
    
    // MARK: UID/Phone Conformity
    
    func uidPhoneConformityCollection() -> CollectionReference {
        self.collection("phonesConformity")
    }
    
    func uidPhoneConformityDoc(byPhone phone: String) -> DocumentReference {
        self.uidPhoneConformityCollection().document(phone)
    }
    
    // MARK: User
    
    func userDoc(withID id: String) -> DocumentReference {
        self.collection("users").document(id)
    }
    
    // User's friends
    func userFriendsDocument(ofUser id: String) -> DocumentReference {
        self.userDoc(withID: id).collection("additionalInfo").document("friends")
    }
    
    // User's Events
    func userEventsCollection(userID id: String) -> CollectionReference {
        self.userDoc(withID: id).collection("events")
    }
    
    // User's Wishes
    func userWishesCollection(userID id: String) -> CollectionReference {
        self.userDoc(withID: id).collection("wishes")
    }
    
//    func userPhonebookCollection(ofUser id: String) -> CollectionReference {
//        self.collection("users").document(id).collection("phonebook")
//    }
    
}

extension Storage {
    // Wish's image
    func wishImagesReference(imageFileName: String? = nil) -> StorageReference {
        guard let image = imageFileName else {
            return self.reference().child("wishes")
        }
        return self.reference().child("wishes/\(image)")
    }
}
