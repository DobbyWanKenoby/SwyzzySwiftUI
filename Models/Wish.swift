//
//  Wish.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 12.02.2022.
//

import Foundation
import UIKit

final class Wish {
    var id: String? = UUID().uuidString
    var description: String
    var create_at: Date
    
    // links
    weak var user: User?
    func assign(user: User) {
        self.user = user
    }
    weak var event: Event?
    
    init(id: String, description: String, create_at: Date) {
        self.id = id
        self.description = description
        self.create_at = create_at
    }
}

extension Wish: CacheImagable {
    var cachePath: String {
        "wishCache"
    }
}
