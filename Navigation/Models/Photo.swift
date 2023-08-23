import UIKit

struct Photo {
    var image: UIImage
}

var photos: [Photo] {
    Array(1...20).map { Photo(image: (UIImage(named: "\($0)") ?? UIImage())) }
}
