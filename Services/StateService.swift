import Foundation
import Combine

protocol StateService {
    var statePublisher: PassthroughSubject<AppState, Never> { get }
}

enum AppState {
    case signOut
    case signIn
    case needUserQuestionnaire
    case finishedUserQuestionnaire
    case needMainFlow
}

class BaseStateService: StateService {
    var statePublisher = PassthroughSubject<AppState, Never>()
}
