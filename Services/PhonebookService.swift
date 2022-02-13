//
//  PhonebookService.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 08.02.2022.
//

import Foundation
import Contacts
import Firebase
import Swinject

protocol PhonebookService: Actor {
    var store: CNContactStore { get }
    var isGrantedPhoneBookAccess: Bool { get }
    var didTryGrantedPhoneBookAccess: Bool { get }
    func getPhoneBookAccess() async throws -> Bool
    // send all contacts to server
    //    func sharePhonebook() async throws -> Bool
    // search friends among all Swizzy users
    func searchFriendsAmongUsers() async throws -> [String]
}

extension PhonebookService {
    var store: CNContactStore {
        CNContactStore()
    }
    
    var isGrantedPhoneBookAccess: Bool {
        guard CNContactStore.authorizationStatus(for: .contacts) == .authorized else {
            return false
        }
        return true
    }
    
    var didTryGrantedPhoneBookAccess: Bool {
        guard CNContactStore.authorizationStatus(for: .contacts) != .notDetermined else {
            return false
        }
        return true
    }
    
    func getPhoneBookAccess() async throws -> Bool {
        return try await store.requestAccess(for: .contacts)
    }
}

actor FirebasePhonebookService: PhonebookService, FirebaseBased {
    
    private var resolver: Resolver
    private var userService: UserService
    private var settingsService: SettingsService
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.userService = resolver.resolve(UserService.self)!
        self.settingsService = resolver.resolve(SettingsService.self)!
    }
    
    func searchFriendsAmongUsers() async throws -> [String] {
        guard let lastSearchContacts = settingsService.currentUserSettings.lastSearchContacts else { return [] }
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[String], Error>) -> Void in
            
            firestore
                .uidPhoneConformityCollection()
                .whereField("timestamp", isGreaterThan: lastSearchContacts)
                .getDocuments { querySnapshot, error in
                    
                    guard error == nil else {
                        continuation.resume(throwing: error!)
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        continuation.resume(returning: [])
                        return
                    }
                    
                    // search phones in PhoneBook
                    let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
                    let newFriendsAtPhonesbook = documents.compactMap { (documentSnapshot) -> String? in
                        
                        let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: documentSnapshot.documentID))
                        guard let contacts = try? self.store.unifiedContacts(matching: predicate, keysToFetch: keys),
                              contacts.count > 0,
                              let uid = documentSnapshot.get("uid") as? String else {
                            return nil
                        }
                        return uid
                    }
                    
                    continuation.resume(returning: newFriendsAtPhonesbook)
                }
        }
    }
}


