import UIKit
import iOSIntPackage
import Dispatch

class PhotosViewController: UIViewController {

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
        
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.id)
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
                print("No processed images received.")
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
    
    /*
     
     Массив исходных параметров один: - photoImages
     Отчет по времени в зависимости от выбранного qos в секундах:
     
     fade - userInteractive: 1.623071583
     fade - userInitiated: 1.8059355
     fade - default: 1.903393166
     fade - utility: 2.453799167
     fade - background: 6.409634625

     */

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupViews() {
        view.backgroundColor = .white
        self.title = "Photo gallery"
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
extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.id, for: indexPath) as! PhotosCollectionViewCell
        
        let photo = photos[indexPath.item]
        cell.photoImageView.image = photo
        
        return cell
    }
}
