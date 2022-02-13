//
//  SettingsService.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 12.02.2022.
//

import Foundation

protocol SettingsService {
    var currentUserSettings: CurrentUserSettings { get set }
}

class BaseSettingsService: SettingsService {
    var currentUserSettings = CurrentUserSettings()
}

struct CurrentUserSettings {
    // date of last phones&contacts searching
    // it uses for searching friends among Swyzzy users
    var lastSearchContacts: Date?
    
    // ??? For updating new profiles image
//    var lastProfileImageUpdate: Date?
    
    @UDPersisted(key: "swyzzy.settingsService.currentUserPhone")
    var phone: PhoneNumber?
}
