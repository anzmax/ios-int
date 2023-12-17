import UIKit

class PhotoCell: UITableViewCell {
    
    static let id = "PhotoCell"
    
    var photosLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = NSLocalizedString("Photos", comment: "")
        label.textColor = .customBlack
        return label
    }()
    
    var photoImageViews: [UIImageView] = {
        
        var images = [UIImageView]()
        
        let firstFourPhotos = Array(photos.prefix(4))
        
        for photo in firstFourPhotos {
            
            let photoView = UIImageView(image: photo.image)
            let photoSize = (UIScreen.main.bounds.width - 12 - 8 * 3) / 4
            photoView.translatesAutoresizingMaskIntoConstraints = false
            photoView.widthAnchor.constraint(equalToConstant: photoSize).isActive = true
            photoView.heightAnchor.constraint(equalToConstant: photoSize).isActive = true
            photoView.contentMode = .scaleAspectFill
            photoView.layer.cornerRadius = 6
            photoView.clipsToBounds = true
            
            images.append(photoView)
        }
        return images
    }()
    
    
    var arrowImageView: UIImageView = {
        let arrowImage = UIImageView()
        arrowImage.image = UIImage(systemName: "arrow.forward")
        arrowImage.tintColor = .customBlack
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        
        return arrowImage
    }()
    
    var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .customWhite
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        
        contentView.backgroundColor = .customWhite
        contentView.addSubview(photosLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(horizontalStackView)
        
        for photoView in photoImageViews {
            horizontalStackView.addArrangedSubview(photoView)
        }
    }
    
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            photosLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            photosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            photosLabel.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor, constant: -12),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            arrowImageView.centerYAnchor.constraint(equalTo: photosLabel.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),
            
            horizontalStackView.topAnchor.constraint(equalTo: photosLabel.bottomAnchor, constant: 12),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}

