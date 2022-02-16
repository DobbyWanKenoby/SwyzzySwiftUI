//
//  User.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 12.02.2022.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

final class User {
    typealias UserType = User
    typealias EventType = Event
    var id: String
    var firstname: String
    var lastname: String
    var birthday: Date
    
    var events: [Event] = []
    func assign(events: [Event]) {
        events.forEach({ event in
            event.user = self
        })
        self.events = events
    }
    
    var wishes: [Wish] = []
    func assign(wishes: [Wish]) {
        wishes.forEach({ wishe in
            wishe.user = self
        })
        self.wishes = wishes
    }
    
    var friends: [User] = []
    
    init(id: String, firstname: String, lastname: String, birthday: Date) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.birthday = birthday
    }
}

extension User: CacheImagable {
    var imagePlaceholder: UIImage {
        UIImage(named: "testUser")!
    }
    var cachePath: String {
        return "userImageCache"
    }
    //    private var _imageURL: URL?
    //    var image: UIImage? {
    //        do {
    //            guard let url = _imageURL else { return nil }
    //            let data = try Data(contentsOf: url)
    //            return UIImage(data: data)
    //        } catch {
    //            return nil
    //        }
    //    }
}

extension User: Equatable {
    // Hashable
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

extension User: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


//public struct User {
//    var id: String
//    var firstname: String {
//        if phonebook_firstname == "" {
//            return original_firstname
//        }
//        return phonebook_firstname
//    }
//    var lastname: String {
//        if phonebook_lastname == "" {
//            return original_lastname
//        }
//        return phonebook_lastname
//    }
//    // Name frome phonebook
//    var phonebook_firstname: String
//    var phonebook_lastname: String
//    // Name from server
//    var original_firstname: String
//    var original_lastname: String
//    
//    var image: UIImage
//    private var imageURL: URL? = nil
//    
//    init(id: String, firstname: String, lastname: String, image: UIImage) {
//        self.id = id
//        self.original_firstname = firstname
//        self.phonebook_firstname = firstname
//        self.original_lastname = lastname
//        self.phonebook_lastname = lastname
//        self.image = image
//    }
//}
