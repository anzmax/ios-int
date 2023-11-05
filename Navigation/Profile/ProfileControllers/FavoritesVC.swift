import UIKit
import CoreData

class FavoritesVC: UIViewController {
    
    var favoritePosts = [Post]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loadFavouritePosts()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavorites), name: .favoritesDidUpdate, object: nil)
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func loadFavouritePosts() {
        favoritePosts = CoreDataService.shared.fetchFavoritePosts()
        tableView.reloadData()
    }
    
    @objc func updateFavorites() {
        favoritePosts = CoreDataService.shared.fetchFavoritePosts()
        tableView.reloadData()
    }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.id, for: indexPath) as! PostCell
        let post = favoritePosts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postToDelete = favoritePosts[indexPath.row]
            favoritePosts.remove(at: indexPath.row)
            CoreDataService.shared.deleteFavoritePost(post: postToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension Notification.Name {
    static let favoritesDidUpdate = Notification.Name("favoritesDidUpdate")
}
