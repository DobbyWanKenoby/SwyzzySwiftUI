import Foundation

enum FirebaseError:  Error {
    case cantGetDocument
}

extension FirebaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cantGetDocument:
            return NSLocalizedString("Can't get the document", comment: "")

        }
    }
}
