import UIKit
import CoreData

class FavoritesVC: UIViewController {
    
    var favoritePosts = [Post]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .customWhite
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
        setupNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavorites), name: .favoritesDidUpdate, object: nil)
    }
    
    func setupNavigationBar() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(promptForAuthor))
        let resetButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetFilter))
        navigationItem.rightBarButtonItems = [resetButton, searchButton]
    }
    
    @objc func promptForAuthor() {
        let alertController = UIAlertController(title: NSLocalizedString("Поиск по автору", comment: ""), message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let searchAction = UIAlertAction(title: NSLocalizedString("Применить", comment: ""), style: .default) { [weak self, weak alertController] _ in
            guard let authorName = alertController?.textFields?.first?.text else { return }
            self?.filterPostsBy(author: authorName)
        }
        
        alertController.addAction(searchAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func filterPostsBy(author: String) {
        favoritePosts = CoreDataService.shared.fetchFavoritePosts().filter { $0.author.lowercased().contains(author.lowercased()) }
        tableView.reloadData()
    }
    
    @objc func resetFilter() {
        loadFavouritePosts()
    }
    
    func setupViews() {
        view.backgroundColor = .customWhite
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Удалить", comment: "")) { [weak self] (action, view, completionHandler) in
            guard let self else { return }
            
            let postToDelete = favoritePosts[indexPath.row]
            
            CoreDataService.shared.persistentContainer.performBackgroundTask { backgroundContext in
                CoreDataService.shared.deleteFavoritePost(post: postToDelete, context: backgroundContext)
                
                DispatchQueue.main.async {
                    self.favoritePosts.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}


extension Notification.Name {
    static let favoritesDidUpdate = Notification.Name("favoritesDidUpdate")
}
