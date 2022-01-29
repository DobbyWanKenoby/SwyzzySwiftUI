import Foundation
import UIKit

struct Country {
    let name: String
    let phoneCode: String
    let imageName: String
}

extension Country {
    var image: UIImage? {
        UIImage(named: imageName)
    }
}

extension Country: Decodable {}

extension Country: Identifiable {
    var id: String { name }
}

extension Country: Equatable {
    
}
