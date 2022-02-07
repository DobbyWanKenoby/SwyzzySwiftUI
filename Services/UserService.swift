//
// Service user authorization
//

import Combine
import Swinject
import FirebaseAuth
import FirebaseFirestore
import SwiftUI


protocol UserService: Actor {
    
    var user: AppUser! { get }
    var userPublisher: PassthroughSubject<AppUser?, Never> { get }
    func update(user: AppUser)
    
    func createRemoteUserStructureIfNeeded() async throws
    func downloadUser() async throws -> AppUser
    func uploadUser() async throws
    
}

actor FirebaseUserService: UserService {
    
    private(set) var user: AppUser! {
        didSet {
            guard user != nil else { return }
            userPublisher.send(user)
        }
    }
    
    func update(user: AppUser) {
        self.user = user
    }
    
    var userPublisher = PassthroughSubject<AppUser?, Never>()
    
    // FIREBASE
    // Firebase user
    private var firebaseUser: FirebaseAuth.User {
        guard let user = Auth.auth().currentUser else {
            fatalError("You cant get firebase user before auth")
        }
        return user
    }
    // Firebase firestore
    private var firestore = Firestore.firestore()
    
    func downloadUser() async throws -> AppUser {
        let userDocRef = self.firestore.collection("users").document("\(self.firebaseUser.uid)")
        let document = try await userDocRef.getDocument()
        guard document.exists else {
            throw FirebaseError.cantGetDocument
        }
        user = AppUser(id: self.firebaseUser.uid,
                       phone: self.firebaseUser.phoneNumber,
                       firstname: document.get("firstname") as? String ?? "",
                       lastname: document.get("lastname") as? String ?? "")
        return user
    }
    
    func createRemoteUserStructureIfNeeded() async throws {
        
        guard let phone = firebaseUser.phoneNumber else { return }
        
        // User main structure
        async let _ = try await firestore.runTransaction { transaction, errorPointer in
            let doc = self.firestore.userDoc(withID: self.firebaseUser.uid)
            let docShapshot: DocumentSnapshot
            do {
                docShapshot = try transaction.getDocument(doc)
            } catch (let error) {
                return error
            }

            guard !docShapshot.exists else { return true }

            transaction.setData([
                "phone": phone,
                "firstname": "",
                "lastname": "",
                "birthday": ""],
                forDocument: doc)
            return true
        }
        
        // User phone to uid structure
        async let _ = try await firestore.runTransaction { transaction, errorPointer in
            let doc = self.firestore.uidPhoneConformityDoc(byPhone: phone)
            let docShapshot: DocumentSnapshot
            do {
                docShapshot = try transaction.getDocument(doc)
            } catch (let error) {
                return error
            }

            guard !docShapshot.exists else { return true }

            transaction.setData([
                "uid": self.firebaseUser.uid],
                forDocument: doc)
            return true
        }
        
    }
    
    func uploadUser() async throws {
        var birthdayString: String = ""
        if let birthday = user.birthsday?.timeIntervalSince1970 {
            birthdayString = String(describing: birthday)
        }
        
        try await firestore.userDoc(withID: firebaseUser.uid).updateData([
            "firstname": user.firstname,
            "lastname": user.lastname,
            "birthday": birthdayString
        ])
        
    }
}

struct Phonebook: Codable {
    var phones: [String] = []
}
