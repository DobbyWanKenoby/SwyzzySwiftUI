//
//  PhoneNumber.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 08.02.2022.
//

import Foundation

struct PhoneNumber: Codable {
    var countryCode: String
    var phone: String
    var fullPhone : String {
        countryCode + phone
    }
}
