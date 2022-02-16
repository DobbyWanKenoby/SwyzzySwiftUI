//
//  WishService.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 16.02.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit
import CryptoKit

protocol WishService: Actor {
    // Current user's wishes
    var wishes: [Wish] { get }
    
    func actualizeCurrentUserWishes() async throws
    func loadWishes(forUser: String) async throws -> [Wish]
    
    func create(wish: Wish, image: UIImage) async throws
}

actor FirebaseWishService: WishService, FirebaseBased {
    var wishes: [Wish] = []
    
    func actualizeCurrentUserWishes() async throws {
        
    }
    func loadWishes(forUser: String)  -> [Wish] {
        return []
    }
    
    func create(wish: Wish, image: UIImage) async throws {
        
        guard let data = getData(fromImage: image) else { return }
        wish.imageHash = MD5(fromData: data)
        
        try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<Void, Error>) -> Void in
            storage.wishImagesReference(imageFileName: wish.id).putData(data, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    continuation.resume(throwing: error!)
                    return
                }
                
                continuation.resume()
            }
        })
        
        _ = try await firestore
            .userWishesCollection(userID: wish.user.id)
            .document(wish.id)
            .setData([
                "createDate": wish.createDate,
                "description": wish.description,
                "imageHash": wish.imageHash ?? ""
            ])

    }
    
    func getData(fromImage image: UIImage) -> Data? {
        image.jpegData(compressionQuality: 1)
    }
}
