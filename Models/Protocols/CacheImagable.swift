import UIKit

protocol CacheImagable {
    var cachePath: String { get }
    var imagePlaceholder: UIImage { get }
    var image: UIImage { get set }
}

extension CacheImagable {
    var image: UIImage {
        get {
            return imagePlaceholder
        }
        set {
            // ...
        }
    }
}
