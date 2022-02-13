import UIKit

protocol CacheImagable {
    var cachePath: String { get }
    var image: UIImage { get set }
}

extension CacheImagable {
    var image: UIImage {
        get {
            return UIImage(named: "testWish")!
        }
        set {
            // ...
        }
    }
}
