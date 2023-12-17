import UIKit
import CoreData
import StorageService
import iOSIntPackage
import SnapKit

enum ProfileSections: Int, CaseIterable {
    case photos
    case posts
}

class ProfileVC: UIViewController {
    
    var profileHeaderView = ProfileHeaderView()
    var user: User?
    private let profileCoordinator: ProfileCoordinatorProtocol
    
    init( profileCoordinator: ProfileCoordinatorProtocol) {
        self.profileCoordinator = profileCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .customWhite
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.id)
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.id)
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.id)
        tableView.estimatedRowHeight = 40
        return tableView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.alpha = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customWhite
        setupViews()
        setupConstraints()
        
//#if DEBUG
//        view.backgroundColor = .gray
//#else
//        view.backgroundColor = .white
//#endif
        
        if let user = self.user {
            updateUser(user: user)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(overlayView)
        overlayView.addSubview(closeButton)
        overlayView.addSubview(avatarImageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarImageTapped))
        profileHeaderView.profileImageView.isUserInteractionEnabled = true
        profileHeaderView.profileImageView.addGestureRecognizer(tapGesture)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    var avatarTopConstraint: NSLayoutConstraint!
    var avatarWidthConstraint: NSLayoutConstraint!
    var avatarHeightConstraint: NSLayoutConstraint!
    var avatarLeftConstraint: NSLayoutConstraint!
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            overlayView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        avatarTopConstraint = avatarImageView.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 16)
        avatarTopConstraint.isActive = true
        avatarWidthConstraint = avatarImageView.widthAnchor.constraint(equalToConstant: 100)
        avatarWidthConstraint.isActive = true
        avatarHeightConstraint = avatarImageView.heightAnchor.constraint(equalToConstant: 100)
        avatarHeightConstraint.isActive = true
        avatarLeftConstraint = avatarImageView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16)
        avatarLeftConstraint.isActive = true
    }
    
    //MARK: - Actions
    
    func updateUser(user: User) {
        self.user = user
        avatarImageView.image = user.avatar
        profileHeaderView.profileImageView.image = user.avatar
        profileHeaderView.nameLabel.text = user.fullName
        profileHeaderView.statusLabel.text = user.status
    }
}

//MARK: - Extensions

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sectionType = ProfileSections.init(rawValue: section) {
            switch sectionType {
            case .photos: return 1
            case .posts: return posts.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let sectionType = ProfileSections.init(rawValue: indexPath.section) {
            
            switch sectionType {
                
            case .photos:
                let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.id, for: indexPath) as! PhotoCell
                return cell
                
            case .posts:
                let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.id, for: indexPath) as! PostCell
                let post = posts[indexPath.row]
                cell.configure(with: post)
                
                let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTappedPost(_:)))
                doubleTapGesture.numberOfTapsRequired = 2
                cell.addGestureRecognizer(doubleTapGesture)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionType = ProfileSections(rawValue: section) {
            
            switch sectionType {
                
            case .photos:
                return profileHeaderView
            case .posts:
                return nil
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let sectionType = ProfileSections(rawValue: section) {
            switch sectionType {
                
            case .photos:
                return 230
            case .posts:
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sectionType = ProfileSections(rawValue: indexPath.section) {
            switch sectionType {
                
            case .photos:
                let photosVC = PhotosVC()
                navigationController?.pushViewController(photosVC, animated: true)
            case .posts:
                break
            }
        }
    }
}

extension ProfileVC {
    
    @objc private func avatarImageTapped() {
        UIView.animate(withDuration: 0.5) {
            self.avatarTopConstraint.constant = 165
            self.avatarWidthConstraint.constant = self.view.bounds.width
            self.avatarHeightConstraint.constant = self.view.bounds.width
            self.avatarLeftConstraint.constant = 0
            self.avatarImageView.layer.cornerRadius = 0
            self.overlayView.alpha = 1.0
            self.view.layoutIfNeeded()
        } completion: { _ in
            
            UIView.animate(withDuration: 0.3, animations: {
                self.closeButton.alpha = 1
            })
        }
    }
    
    @objc private func closeButtonTapped() {
        UIView.animate(withDuration: 0.5) {
            self.avatarTopConstraint.constant = 16
            self.avatarWidthConstraint.constant = 100
            self.avatarHeightConstraint.constant = 100
            self.avatarLeftConstraint.constant = 16
            self.avatarImageView.layer.cornerRadius = 50
            self.overlayView.alpha = 0.0
            self.closeButton.alpha = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func doubleTappedPost(_ gesture: UITapGestureRecognizer) {
        guard let cell = gesture.view as? PostCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let heartImageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        heartImageView.frame = CGRect(x: cell.contentView.frame.width / 2, y: cell.contentView.frame.height / 2, width: 100, height: 100)
        heartImageView.center = gesture.location(in: cell)
        heartImageView.contentMode = .scaleAspectFill
        heartImageView.tintColor = .red
        cell.contentView.addSubview(heartImageView)
        
        UIView.animate(withDuration: 0.5, animations: {
            heartImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            heartImageView.alpha = 0
        }) { _ in
            heartImageView.removeFromSuperview()
        }
        
        let post = posts[indexPath.row]
        CoreDataService.shared.addPostToFavorites(post: post)
        
        NotificationCenter.default.post(name: .favoritesDidUpdate, object: nil)
        
        CoreDataService.shared.persistentContainer.performBackgroundTask { _ in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                for controller in navigationController?.viewControllers ?? [] {
                    if let favVC = controller as? FavoritesVC {
                        favVC.favoritePosts = CoreDataService.shared.fetchFavoritePosts()
                        favVC.tableView.reloadData()
                    }
                }
            }
        }
    }
}
