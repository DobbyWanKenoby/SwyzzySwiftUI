//
//  Crypto.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 16.02.2022.
//

import Foundation
import CryptoKit

func MD5(fromData data: Data) -> String {
    let digest = Insecure.MD5.hash(data: data)

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
