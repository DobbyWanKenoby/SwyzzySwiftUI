//
// Service user authorization
//

import Combine
import Swinject
import FirebaseAuth
import FirebaseFirestore
import SwiftUI


protocol UserService: Actor {
    var user: User! { get }
    var userPublisher: PassthroughSubject<User?, Never> { get }
    func update(user: User)
    
    func createRemoteUserStructureIfNeeded() async throws
    func downloadUser() async throws -> User
    func uploadUser() async throws
    
}

actor FirebaseUserService: UserService, FirebaseBased {
    private(set) var user: User! {
        didSet {
            guard user != nil else { return }
            userPublisher.send(user)
        }
    }
    
    private var resolver: Resolver
    private var authService: AuthService
    private var settingsService: SettingsService
    
    private var subscribers = Set<AnyCancellable>()
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.authService = resolver.resolve(AuthService.self)!
        self.settingsService = resolver.resolve(SettingsService.self)!
    }
    
    func update(user: User) {
        self.user = user
    }
    
    var userPublisher = PassthroughSubject<User?, Never>()
    
    func downloadUser() async throws -> User {

        async let userAsyncDoc = try await getBaseUserDoc()
//        async let friendsAsyncDoc = try await getFriendsUserDoc()
        let userDoc = try await userAsyncDoc
        //let friendsDoc = try await friendsAsyncDoc
        
        // Birthday
        var birthday: Date?
        if let rawBirthday = userDoc.get("birthday") as? String {
            birthday = DateConverter.convert(birthday: rawBirthday)
        }
        
        user = User(id: userDoc.documentID,
                       firstname: userDoc.get("firstname") as? String ?? "",
                       lastname: userDoc.get("lastname") as? String ?? "",
                       birthday: birthday ?? Date())
        
        // TODO: Add download friends profiles
        
        // Date of last searching of contacts
        var lastSearchContacts: Date?
        if let timestamp = userDoc.get("lastsearchcontacts") as? Timestamp,
           let timeinterval = TimeInterval("\(timestamp.seconds).\(timestamp.nanoseconds)") {
            lastSearchContacts = Date(timeIntervalSince1970: timeinterval)
        } else {
            lastSearchContacts = Date(timeIntervalSinceReferenceDate: TimeInterval())
        }
        
        settingsService.currentUserSettings.lastSearchContacts = lastSearchContacts
        
        return user
    }
    
    private func getBaseUserDoc() async throws -> DocumentSnapshot {
        let userDocRef = self.firestore.userDoc(withID: firebaseUser.uid)
        let document = try await userDocRef.getDocument()
        guard document.exists else {
            throw FirebaseError.cantGetDocument
        }
        return document
    }
    
    private func getFriendsUserDoc() async throws -> DocumentSnapshot {
        let userDocRef = self.firestore.userFriendsDocument(ofUser: firebaseUser.uid)
        let document = try await userDocRef.getDocument()
        guard document.exists else {
            throw FirebaseError.cantGetDocument
        }
        return document
    }
    
    func createRemoteUserStructureIfNeeded() async throws {
        try await withThrowingTaskGroup(of: Void.self) { taskGroup in
            taskGroup.addTask {
                try await self.createUserStructure()
                try await self.createFriendStructure()
            }
            taskGroup.addTask {
                try await self.createPhoneConformityStructure()
            }
            
            try await taskGroup.waitForAll()
        }
        
    }
    
    private func createPhoneConformityStructure() async throws {
        guard let phone = settingsService.currentUserSettings.phone else { return }
        try await firestore.runTransaction { transaction, errorPointer in
            let doc = self.firestore.uidPhoneConformityDoc(byPhone: phone.fullPhone)
            let docShapshot: DocumentSnapshot
            do {
                docShapshot = try transaction.getDocument(doc)
            } catch (let error) {
                return error
            }

            guard !docShapshot.exists else { return true }

            transaction.setData([
                "timestamp": Date(),
                "uid": self.firebaseUser.uid],
                forDocument: doc)
            return true
        }
    }
    
    private func createUserStructure() async throws {
        guard let phone = settingsService.currentUserSettings.phone else { return }
        try await firestore.runTransaction { transaction, errorPointer in
            let doc = self.firestore.userDoc(withID: self.firebaseUser.uid)
            let docShapshot: DocumentSnapshot
            do {
                docShapshot = try transaction.getDocument(doc)
            } catch (let error) {
                return error
            }

            guard !docShapshot.exists else { return true }

            transaction.setData([
                "phone": phone.fullPhone,
                "countrycode": phone.countryCode,
                "firstname": "",
                "lastname": "",
                "birthday": "",
                "lastsearchcontacts": ""],
                forDocument: doc)
            return true
        }
    }
    
    private func createFriendStructure() async throws {
        guard let phone = settingsService.currentUserSettings.phone else { return }
        try await firestore.runTransaction { transaction, errorPointer in
            let doc = self.firestore.userFriendsDocument(ofUser: self.firebaseUser.uid)
            let docShapshot: DocumentSnapshot
            do {
                docShapshot = try transaction.getDocument(doc)
            } catch (let error) {
                return error
            }

            guard !docShapshot.exists else { return true }

            transaction.setData([
                "friends": phone.fullPhone],
                forDocument: doc)
            return true
        }
    }
    
    func uploadUser() async throws {
        
        var userMainData: [AnyHashable: Any] = [:]
        
        // name
        userMainData["firstname"] = user.firstname
        userMainData["lastname"] = user.lastname
        // birthday
        userMainData["birthday"] = DateConverter.convert(birthday: user.birthday)
        // last contacts searching
        if let lastSearchContacts = settingsService.currentUserSettings.lastSearchContacts {
            userMainData["lastsearchcontacts"] = lastSearchContacts
        }
        
        async let _ = try await firestore.userDoc(withID: firebaseUser.uid).updateData(userMainData)
        async let _ = try await firestore.userFriendsDocument(ofUser: firebaseUser.uid).updateData(["friends":user.friends])
        
    }
}

struct Phonebook: Codable {
    var phones: [String] = []
}
