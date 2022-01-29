import Foundation

enum AuthError:  Error {
    case wrongPhoneNumber
    case missingCredentials
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wrongPhoneNumber:
            return NSLocalizedString("Wrong phone number", comment: "User entered wrong phone number on Auth screen")
        case .missingCredentials:
            return NSLocalizedString("Missing creddentials", comment: "Missing credentials from user or Firebase")
        }
    }
}
