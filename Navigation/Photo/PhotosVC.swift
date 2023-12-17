import UIKit
import iOSIntPackage
import Dispatch

class PhotosVC: UIViewController {

    let imageProcessor = ImageProcessor()
    var photos = [UIImage]()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        let itemsCountInRow: CGFloat = 3
        let totalSpacing: CGFloat = (itemsCountInRow - 1) * layout.minimumInteritemSpacing
        let cellWidth: CGFloat = (UIScreen.main.bounds.width - totalSpacing - (2 * padding)) / itemsCountInRow
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()

    var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray.withAlphaComponent(0.2)
        return view
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        let startTime = DispatchTime.now()
    
        imageProcessor.processImagesOnThread(sourceImages: photoImages, filter: .fade, qos: .userInteractive) { processedImages in
            
            guard !processedImages.isEmpty else {
                return
            }

            var updatedPhotos = [UIImage]()
            
            for (index, image) in processedImages.enumerated() {
                if let image {
                    let updatedImage = UIImage(cgImage: image)
                    updatedPhotos.append(updatedImage)
                } else {
                    updatedPhotos.append(self.photos[index])
                }
            }

            DispatchQueue.main.async {
                self.photos = updatedPhotos
                self.collectionView.reloadData()
                
                let endTime = DispatchTime.now()
                let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                let timeInterval = Double(nanoTime) / 1_000_000_000
                
                print("Затраченное время: \(timeInterval) секунд")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupViews() {
        view.backgroundColor = .white
        self.title = NSLocalizedString("Photo gallery", comment: "")
        view.addSubview(topView)
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 110),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    @objc func goBackScreen() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Extensions
extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.id, for: indexPath) as! PhotosCell
        
        let photo = photos[indexPath.item]
        cell.photoImageView.image = photo
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImages = photos.compactMap { $0.cgImage }
        let photoDetailVC = PhotoDetailVC()
        photoDetailVC.images = selectedImages
        
        photoDetailVC.slideshowDidFinish = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}
