import UIKit

class PostViewController: UIViewController {
    
    lazy var infoBarButtonItem: UIBarButtonItem = {
        var button = UIBarButtonItem.init(title: "Info", style: .plain, target: self, action: #selector(showInfoScreen))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        title = "My Post"
        
        setupViews()
        setupConstraints()
    }
    
    @objc func showInfoScreen() {
        let infoVC = InfoViewController.init()
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    func setupViews() {
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }
    
    func setupConstraints() {
    }
}

