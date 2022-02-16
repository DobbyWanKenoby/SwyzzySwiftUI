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
    private var eventService: EventService
    
    private var subscribers = Set<AnyCancellable>()
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.authService = resolver.resolve(AuthService.self)!
        self.settingsService = resolver.resolve(SettingsService.self)!
        self.eventService = resolver.resolve(EventService.self)!
    }
    
    func update(user: User) {
        self.user = user
    }
    
    var userPublisher = PassthroughSubject<User?, Never>()
    
    // MARK: - Upload data
    
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
        let friends = user.friends.map { $0.id }
        async let _ = try await firestore.userFriendsDocument(ofUser: firebaseUser.uid).updateData(["friends": friends])
        
    }
    
   // MARK: - Download data
    
    func downloadUser() async throws -> User {
        async let userDoc = try await getBaseUserDoc(withID: firebaseUser.uid)
        let user = getUserBaseData(fromDoc: try await userDoc)
        settingsService.currentUserSettings.lastSearchContacts = getUserLastSearchContacts(fromDoc: try await userDoc)
        
        async let events = try await eventService.getEvents(ofUser: firebaseUser.uid)
        user.assign(events: try await events)
        
        async let userFriendsDoc = try await getFriendsUserDoc(withID: firebaseUser.uid)
        user.friends = try await getUserFriends(fromDoc: try await userFriendsDoc)
        return user
    }
    
    private func getUserFriends(fromDoc userDoc: DocumentSnapshot) async throws -> [User] {
        guard let friendsID = userDoc["friends"] as? [String] else { return [] }
        
        return try await withThrowingTaskGroup(of: User.self) { group in
            var friends = [User]()
            friends.reserveCapacity(friendsID.count)
            for userid in friendsID {
                group.addTask {
                    let userDoc = try await self.getBaseUserDoc(withID: userid)
                    let friend = await self.getUserBaseData(fromDoc: userDoc)
                    var events = [Event]()
                    for event in try await self.eventService.getEvents(ofUser: userid) {
                        events.append(event)
                    }
                    friend.assign(events: events)
                    return friend
                }
            }
            
            for try await friend in group {
                friends.append(friend)
            }
            return friends
        }
    }
    
    private func getUserBaseData(fromDoc userDoc: DocumentSnapshot) -> User {
        // Birthday
        var birthday: Date?
        if let rawBirthday = userDoc.get("birthday") as? String {
            birthday = DateConverter.convert(birthday: rawBirthday)
        }
        user = User(id: userDoc.documentID,
                       firstname: userDoc.get("firstname") as? String ?? "",
                       lastname: userDoc.get("lastname") as? String ?? "",
                       birthday: birthday ?? Date())
        return user
    }
    
    private func getUserLastSearchContacts(fromDoc userDoc: DocumentSnapshot) -> Date? {
        // Date of last searching of contacts
        var lastSearchContacts: Date?
        if let timestamp = userDoc.get("lastsearchcontacts") as? Timestamp,
           let timeinterval = TimeInterval("\(timestamp.seconds).\(timestamp.nanoseconds)") {
            lastSearchContacts = Date(timeIntervalSince1970: timeinterval)
        } else {
            lastSearchContacts = Date(timeIntervalSinceReferenceDate: TimeInterval())
        }
        return lastSearchContacts
    }
    
    private func getBaseUserDoc(withID id: String) async throws -> DocumentSnapshot {
        let userDocRef = self.firestore.userDoc(withID: id)
        let document = try await userDocRef.getDocument()
        guard document.exists else {
            throw FirebaseError.cantGetDocument
        }
        return document
    }
    
    private func getFriendsUserDoc(withID id: String) async throws -> DocumentSnapshot {
        let userDocRef = self.firestore.userFriendsDocument(ofUser: id)
        let document = try await userDocRef.getDocument()
        guard document.exists else {
            throw FirebaseError.cantGetDocument
        }
        return document
    }
    
    // MARK: - Create base structure
    
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
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
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
//            let doc = self.firestore.userDoc(withID: UUID().uuidString)
            let docShapshot: DocumentSnapshot
            do {
                docShapshot = try transaction.getDocument(doc)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
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
        try await firestore.runTransaction { transaction, errorPointer in
            let doc = self.firestore.userFriendsDocument(ofUser: self.firebaseUser.uid)
            let docShapshot: DocumentSnapshot
            do {
                docShapshot = try transaction.getDocument(doc)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard !docShapshot.exists else { return true }

            transaction.setData([
                "friends": []],
                forDocument: doc)
            return true
        }
    }
}
