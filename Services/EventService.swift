//
//  EventService.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 08.02.2022.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol EventService: Actor {
    // event of current user
//    var events: [Event] { get }
    
    // create event for current user
    func create(event: Event) throws
    func update(event: Event) throws
    
    func getEvents(ofUser id: String) async throws -> [Event]
}

actor FirebaseEventService: EventService, FirebaseBased {
//    var events: [Event] = []
    
    func create(event: Event) throws {
        _ = try firestore
            .userEventsCollection(userID: firebaseUser.uid)
            .addDocument(from: EventFirebaseContainer(fromEvent: event))
//        events.append(event)
    }
    
    func getEvents(ofUser id: String) async throws -> [Event] {
        try await withCheckedThrowingContinuation { continuation in
            firestore.userEventsCollection(userID: id).getDocuments { querySnapshot, error in
                
                guard error == nil else {
                    continuation.resume(throwing: error!)
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    continuation.resume(returning: [])
                    return
                }
                
                let events = documents.compactMap { (documentSnapshot) -> Event? in
                    guard let event = try? documentSnapshot.data(as: EventFirebaseContainer.self) else { return nil }
                    return event.convertToEvent()
                }
                continuation.resume(returning: events)
            }
        }
    }
    
    func update(event: Event) throws {
       try create(event: event)
    }
}


