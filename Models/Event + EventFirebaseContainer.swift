//
//  Event.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 08.02.2022.
//

import Foundation
import FirebaseFirestoreSwift


final class Event {
    typealias UserType = User
    var id: String = UUID().uuidString
    var title: String
    var date: Date
    var createDate: Date = Date()
    weak var user: User? = nil
    
    init(id: String, title: String, date: Date, createDate: Date) {
        self.id = id
        self.title = title
        self.date = date
        self.createDate = createDate
    }
    
    init(id: String, title: String, date: Date) {
        self.id = id
        self.title = title
        self.date = date
    }
    
    init(title: String, date: Date) {
        self.title = title
        self.date = date
    }
}

// Container to transit data from/to Firebase

struct EventFirebaseContainer: Codable {
    @DocumentID
    var id: String? = UUID().uuidString
    var title: String
    // date as string (format at DateConverter class)
    // used to exclude timezone influence
    var _date: String
    var createDate: Date
    var date: Date {
        return DateConverter.convert(birthday: _date) ?? Date()
    }

    init(fromEvent source: Event) {
        self.id = source.id
        self.title = source.title
        self._date = DateConverter.convert(birthday: source.date)
        self.createDate = source.createDate
    }
    
    func convertToEvent() -> Event {
        Event(id: id!, title: title, date: date, createDate: createDate)
    }

    enum CodingKeys: String, CodingKey {
        case title
        case _date = "date"
        case createDate
    }
}
