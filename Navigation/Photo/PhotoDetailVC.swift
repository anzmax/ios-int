import UIKit

class PhotoDetailVC: UIViewController {
    
    var selectedImage: UIImage?
    var images = [CGImage]()
    var currentIndex: Int = 0
    var timer: Timer?
    
    var slideshowDidFinish: (() -> Void)?
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        startSlideshow()
    }
    
    private func setupViews() {
        view.backgroundColor = .customWhite
        view.addSubview(imageView)
        if let image = selectedImage {
            imageView.image = image
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func startSlideshow() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
    }
    
    @objc func nextImage() {
        imageView.image = UIImage(cgImage: images[currentIndex])
        if currentIndex >= images.count - 1 {
            currentIndex = 0
            timer?.invalidate()
            timer = nil
            slideshowDidFinish?()
        } else {
            currentIndex += 1
        }
    }
}

