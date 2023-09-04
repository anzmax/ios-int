import UIKit

struct Photo {
    var image: UIImage
}

var photos: [Photo] {
    Array(1...20).map { Photo(image: (UIImage(named: "\($0)") ?? UIImage())) }
}

var photoImages: [UIImage] {
    Array(1...20).map { (UIImage(named: "\($0)") ?? UIImage()) }
}

