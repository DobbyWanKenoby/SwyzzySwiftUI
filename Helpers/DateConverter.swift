import Foundation

class DateConverter {
    
    private static var dateFormat = "MM/dd/yyyy"
    
    static func convert(birthday: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Self.dateFormat
        return formatter.string(from: birthday)
    }
    
    static func convert(birthday: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Self.dateFormat
        return formatter.date(from: birthday)
    }
}
