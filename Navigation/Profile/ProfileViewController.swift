import UIKit

enum ProfileSections: Int, CaseIterable {
    
    case photos
    case posts
}

class ProfileViewController: UIViewController {
    
    var profileHeaderView = ProfileHeaderView()
    
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.id)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.id)
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
    
    private lazy var avatarImageView: UIImageView = {
        
        let headerView = profileHeaderView
        let image = headerView.profileImageView.image
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    
    private func setupViews() {
        
        view.backgroundColor = .white
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
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
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
                let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.id, for: indexPath) as! PhotosTableViewCell
                return cell
                
            case .posts:
                let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.id, for: indexPath) as! PostTableViewCell
                let post = posts[indexPath.row]
                cell.configure(with: post)
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
        
        if let sectionType = ProfileSections(rawValue: indexPath.row) {
            
            switch sectionType {
                
            case .photos:
                let photosVC = PhotosViewController()
                navigationController?.pushViewController(photosVC, animated: true)
            case .posts:
                break
            }
        }
        
    }
}

extension ProfileViewController {
    
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
    
}


