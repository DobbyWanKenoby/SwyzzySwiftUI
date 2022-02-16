//
//  Wish.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 12.02.2022.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift
import CloudKit
import Swinject

final class Wish {
    var id: String = UUID().uuidString
    var description: String
    var createDate: Date
    var imageHash: String? = nil
    var image: UIImage {
        return UIImage()
    }
    
    private var wishService: WishService
    
    // links
    weak var user: User!
    weak var event: Event?
    
    init(resolver: Resolver, id: String, description: String, createDate: Date, user: User) {
        self.wishService = resolver.resolve(WishService.self)!
        self.id = id
        self.description = description
        self.createDate = createDate
        self.user = user
    }
    
    init(resolver: Resolver, description: String, createDate: Date, user: User) {
        self.wishService = resolver.resolve(WishService.self)!
        self.description = description
        self.createDate = createDate
        self.user = user
    }
}

extension Wish: CacheImagable {
    var imagePlaceholder: UIImage {
        UIImage(named: "testWish")!
    }
    var cachePath: String {
        "wishCache"
    }
}

struct WishFirebaseContainer: Codable {
    @DocumentID
    var id: String? = UUID().uuidString
    var createDate: Date
    var description: String
    var imageHash: String?

    init(fromWish source: Wish, imageHash: String? = nil) {
        self.id = source.id
        self.createDate = source.createDate
        self.description = source.description
        self.imageHash = imageHash
    }
    
//    func convertToWish(forUser user: User, resolver: Resolver) -> Wish {
//        Wish(id: id!, description: description, createDate: createDate, user: user)
//    }

    enum CodingKeys: String, CodingKey {
        case createDate
        case description
        case imageHash
    }
}
